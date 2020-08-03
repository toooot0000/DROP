extends Control

#const GAME_SCENE = preload("res://Game/GameScene/GameScene.tscn")
#const ENTRY_SCENE = preload()

export(PackedScene)var GAME_SCENE = load("res://Game/GameScene/GameScene.tscn")
export(PackedScene)var ENTRY_SCENE = load("res://Game/EntryScene/EntryScene.tscn")
export(PackedScene)var SETTING_SCENE = load("res://Game/SettingScene/SettingScene.tscn")
export(PackedScene)var LEVEL_CHOOSE_SCENE = load("res://Game/LevelChooseScene/LevelChooseScene.tscn")
export(PackedScene)var GAME_PASS_SCENE = load("res://Game/GamePassScene/GamePassScene.tscn")
export(PackedScene)var GAME_FAIL_SCENE = load("res://Game/GameFailScene/GameFailScene.tscn")

signal setting_close

func _ready():
	$AdMob.load_banner()

func call_scene(_name:String, scene:PackedScene)->Node:
	var _scene = scene.instance()
	add_child(_scene)
	_scene.name = _name
	_scene.connect("call_setting", self, "_on_call_setting")
	_scene.connect("call_back", self, "_on_call_back")
	connect("setting_close", _scene, "_on_setting_close")
	return _scene

func call_game_scene(lv_number:int):
	var game = call_scene("GameScene", GAME_SCENE)
	game.level_start(lv_number)
	game.connect("game_pass", self, "_on_game_pass")
	game.connect("game_fail", self, "_on_game_fail")
	return game

func call_setting_scene()->Node:
	var _scene = SETTING_SCENE.instance()
	add_child(_scene)
	_scene.name = "SettingScene"
	_scene.connect("setting_close", self, "_on_setting_close")
	return _scene

func _on_EntryScene_start_game():
	call_game_scene(GlPlayer.current_level)
	pass # Replace with function body.

func _on_EntryScene_start_select_level():
	var level_choose = call_scene("LevelChooseScene", LEVEL_CHOOSE_SCENE)
	level_choose.connect("choose_level", self, "_on_LevelChoose_choose_level")
	pass # Replace with function body.

func _on_call_setting():
	call_setting_scene()
#	var _scene = SETTING_SCENE.instance()
#	add_child(_scene)
#	_scene.name = "SettingScene"
#	_scene.connect("close", self, "_on_setting_close")
	pass # Replace with function body.

func _on_call_back(scene):
	scene.queue_free()
	var entry = call_scene("EntryScene", ENTRY_SCENE)
	entry.connect("start_game", self, "_on_EntryScene_start_game")
	entry.connect("start_select_level", self, "_on_EntryScene_start_select_level")
	pass

func _on_setting_close():
	$SettingScene.queue_free()
	GlPlayer.save()
	emit_signal("setting_close")
	pass

func _on_game_pass():
	
	var game_pass = call_scene("GamePassScene", GAME_PASS_SCENE)
	var pass_state = $GameScene.pass_state
	if pass_state["lv_num"] == GlPlayer.current_level:
		GlPlayer.pass_level(pass_state["star_num"])
	game_pass.set_pass_state(pass_state)
	game_pass.connect("replay", self, "_on_GamePass_replay")
	game_pass.connect("next", self, "_on_GamePass_next")
	$GameScene.queue_free()
	pass

func _on_game_fail(type, lv_num):	
	var game_pass = call_scene("GameFailScene", GAME_FAIL_SCENE)
	game_pass.set_fail_type(type, lv_num)
	game_pass.connect("replay", self, "_on_GameFailScene_replay")
	$GameScene.queue_free()
	pass

func _on_GameFailScene_replay(lv_num):
	$GameFailScene.queue_free()
	call_game_scene(lv_num)

func _on_GamePass_replay(lv_num):
	$GamePassScene.queue_free()
	call_game_scene(lv_num)
	pass

func _on_GamePass_next(lv_num):
	$GamePassScene.queue_free()
	call_game_scene(lv_num+1)
	pass

func _on_LevelChoose_choose_level(lv_num):
	$LevelChooseScene.queue_free()
	call_game_scene(lv_num)
	pass
