extends Control

#const GAME_SCENE = preload("res://Game/GameScene/GameScene.tscn")
#const ENTRY_SCENE = preload()

export(PackedScene)var GAME_SCENE = load("res://Game/GameScene/GameScene.tscn")
export(PackedScene)var ENTRY_SCENE = load("res://Game/EntryScene/EntryScene.tscn")
export(PackedScene)var SETTING_SCENE = load("res://Game/SettingScene/SettingScene.tscn")
export(PackedScene)var LEVEL_CHOOSE_SCENE = load("res://Game/LevelChooseScene/LevelChooseScene.tscn")
export(PackedScene)var GAME_PASS_SCENE = load("res://Game/GamePassScene/GamePassScene.tscn")
export(PackedScene)var GAME_FAIL_SCENE = load("res://Game/GameFailScene/GameFailScene.tscn")
export(PackedScene)var FIRST_GAME_SCENE = load("res://Game/GameScene/IntroStages/FirstGame/FirstGameScene.tscn")
export(PackedScene)var SECOND_GAME_SCENE = load("res://Game/GameScene/IntroStages/SecondGame/SecondGameScene.tscn")
export(PackedScene)var THIRD_GAME_SCENE = load("res://Game/GameScene/IntroStages/ThirdGame/ThirdGameScene.tscn")


signal setting_close

var game_scene:Node

func _ready():
	$AdMob.load_banner()
	if GlPlayer.is_new_player:
		game_scene = FIRST_GAME_SCENE.instance()
		add_child(game_scene)
		game_scene.name = "GameScene"
		game_scene.connect("game_pass", self, "_on_game_pass")
		game_scene.connect("game_fail", self, "_on_game_fail")
	else:
		call_entry_scene()

func call_scene(_name:String, scene:PackedScene)->Node:
	var _scene = scene.instance()
	add_child(_scene)
	_scene.name = _name
	_scene.connect("call_setting", self, "_on_call_setting")
	_scene.connect("call_back", self, "_on_call_back")
	connect("setting_close", _scene, "_on_setting_close")
	return _scene

func call_game_scene(lv_number:int):
	game_scene = call_scene("GameScene", GAME_SCENE)
	game_scene.level_start(lv_number)
	game_scene.connect("game_pass", self, "_on_game_pass")
	game_scene.connect("game_fail", self, "_on_game_fail")

func call_entry_scene():
	var entry = call_scene("EntryScene", ENTRY_SCENE)
	entry.connect("start_game", self, "_on_EntryScene_start_game")
	entry.connect("start_select_level", self, "_on_EntryScene_start_select_level")
	return entry

func call_setting_scene()->Node:
	var _scene = SETTING_SCENE.instance()
	add_child(_scene)
	_scene.name = "SettingScene"
	_scene.connect("setting_close", self, "_on_setting_close")
	return _scene

func _on_EntryScene_start_game():
	$EntryScene.queue_free()
	call_game_scene(GlPlayer.current_level)
	pass # Replace with function body.

func _on_EntryScene_start_select_level():
	var level_choose = call_scene("LevelChooseScene", LEVEL_CHOOSE_SCENE)
	level_choose.connect("choose_level", self, "_on_LevelChoose_choose_level")
	pass # Replace with function body.

func _on_call_setting():
	call_setting_scene()
	pass # Replace with function body.

func _on_call_back(scene):
	scene.queue_free()
	call_entry_scene()
	pass

func _on_setting_close():
	$SettingScene.queue_free()
	GlPlayer.save()
	emit_signal("setting_close")
	pass

func call_game_pass(pass_state):
	var game_pass = call_scene("GamePassScene", GAME_PASS_SCENE)
	game_pass.set_pass_state(pass_state)
	game_pass.connect("replay", self, "_on_GamePass_replay")
	game_pass.connect("next", self, "_on_GamePass_next")

func _on_game_pass():
	check_border_guide()
	var pass_state = game_scene.pass_state
	
	match pass_state["lv_num"]:
		1:
			if pass_state["is_in_guide"]:
				game_scene.queue_free()
				game_scene = call_scene("GameScene", SECOND_GAME_SCENE)
				game_scene.connect("game_pass", self, "_on_game_pass")
				game_scene.connect("game_fail", self, "_on_game_fail")
			else:
				call_game_pass(pass_state)
			pass
		2:
			if pass_state["is_in_guide"]:
				game_scene.queue_free()
				game_scene = call_scene("GameScene", THIRD_GAME_SCENE)
				game_scene.connect("game_pass", self, "_on_game_pass")
				game_scene.connect("game_fail", self, "_on_game_fail")
				GlPlayer.is_new_player = false
			else:
				call_game_pass(pass_state)
			pass
		_:
			game_scene.queue_free()
			call_game_pass(pass_state)
			pass
		
	if pass_state["lv_num"] == GlPlayer.current_level:
		GlPlayer.pass_level(pass_state["star_num"])
	pass

func _on_game_fail(type, lv_num):	
	check_border_guide()
	game_scene.queue_free()
	var game_pass = call_scene("GameFailScene", GAME_FAIL_SCENE)
	game_pass.set_fail_type(type, lv_num)
	game_pass.connect("replay", self, "_on_GameFailScene_replay")
	pass

func _on_GameFailScene_replay(lv_num):
	$GameFailScene.queue_free()
	call_game_scene(lv_num)

func _on_GamePass_replay(lv_num):
	$GamePassScene.queue_free()
	call_game_scene(lv_num)
	pass

func check_border_guide():
	if game_scene and game_scene.is_border_guide_triggered:
		GlPlayer.is_border_guide_triggered = true
		GlPlayer.save()
	pass

func _on_GamePass_next(lv_num):
	$GamePassScene.queue_free()
	call_game_scene(lv_num+1)
	pass

func _on_LevelChoose_choose_level(lv_num):
	$LevelChooseScene.queue_free()
	call_game_scene(lv_num)
	pass
