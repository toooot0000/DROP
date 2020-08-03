extends Control

signal game_pass
signal game_fail(type, lv_num)
signal game_restart
signal call_setting
signal call_back(inst)
#signal game_ui_setup

export(PackedScene)var current_level_scene setget set_current_level_scene

var current_level:Node
var current_level_num:int
var pass_state:Dictionary
var is_anim_finished:bool = false
var is_all_setup:bool = false

func _ready():
#	$AnimationPlayer.play("in")
#	yield($AnimationPlayer, "animation_finished")
#	level_start(GlPlayer.current_level)
#	yield($Level, "level_setup_finished")
#	$TimeBar/Time.is_working = true
	pass

func set_current_level_scene(value:PackedScene):
	current_level_scene = value
	current_level = current_level_scene.instance()
	current_level.name = "Level"
	add_child(current_level)
	$TimeBar.star1time = current_level.time_one_star
	$Stars.update_star_position([current_level.time_three_star,current_level.time_two_star,current_level.time_one_star])
	pass

func _on_Level_level_pass():
	var _time = $TimeBar/Time.time
	pass_state["time"] = _time
	if _time<=current_level.time_three_star:
		pass_state["star_num"] = 3
	elif _time<=current_level.time_two_star:
		pass_state["star_num"] = 2
	else:
		pass_state["star_num"] = 1
	pass_state["lv_num"] = current_level_num
	emit_signal("game_pass")
	pass

func _on_Level_level_fail(type):
	emit_signal('game_fail', type, current_level_num)
	pass

func _on_Level_level_restart():
#	emit_signal('game_fail')
	restart_level()
	pass

func level_start(level_number:int):
	
	current_level_num = level_number
	is_all_setup = false
	$LevelNum.text = "Lv."+str(level_number)
	$AnimationPlayer.play("in")
	$TimeBar/Time.reset()
	yield($AnimationPlayer, "animation_finished")
	
	var level_scene = load("res://Game/Levels/LevelScenes/"+str(level_number) +".tscn")
	if level_scene:
		self.set_current_level_scene(level_scene)
	else:
		self.set_current_level_scene(load("res://Game/Levels/LevelBase.tscn"))
	
	yield($Level, "level_setup_finished")
	$TimeBar/Time.set_working(true)
	is_all_setup = true
	
	pass

func restart_level():
	#重新加载关卡
	if current_level:
		current_level.queue_free()
		pass
	yield(get_tree(), "idle_frame")
	is_all_setup = false
	$TimeBar/Time.reset()
	
	var level_scene = load("res://Game/Levels/LevelScenes/"+str(current_level_num) +".tscn")
	if level_scene:
		set_current_level_scene(level_scene)
	else:
		set_current_level_scene(load("res://Game/Levels/LevelBase.tscn"))
	
	yield($Level, "level_setup_finished")
	$TimeBar/Time.set_working(true)
	is_all_setup = true
	
	pass

func _on_Back_button_down():
	if !is_anim_finished or !is_all_setup:
		return
	freeze()
	$AnimationPlayer.play("out")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("call_back", self)
	pass # Replace with function body

func _on_Replay_button_down():
	if !is_anim_finished or !is_all_setup:
		return
	restart_level()
	pass # Replace with function body.

func _on_Setting_button_down():
	if !is_anim_finished or !is_all_setup:
		return
	freeze()
	emit_signal("call_setting")
	pass # Replace with function body.

func freeze():
	if current_level:
		current_level.freeze()
	$TimeBar/Time.set_working(false)
	pass

func active():
	if current_level:
		current_level.active()
	$TimeBar/Time.set_working(true)

func _on_setting_close():
	active()
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	is_anim_finished = true
	pass # Replace with function body.

func _on_AnimationPlayer_animation_started(anim_name):
	is_anim_finished = false
	pass # Replace with function body.
