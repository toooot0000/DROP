extends Control
class_name GameScene


signal game_pass
signal game_fail(type, lv_num)
signal game_restart
signal call_setting
signal call_back(inst)
#signal game_ui_setup
signal player_tap
signal player_drag(mouse_point)
signal player_stop_action

export(PackedScene)var current_level_scene setget set_current_level_scene
export(Dictionary)var intro_info = {}

export(float)var slide_speed = 10
export(float)var slide_wait_time = 0.2

export(bool)var is_testing_level = false
export(int)var testing_level_num = 1

var current_level:Node
var current_level_num:int
var pass_state:Dictionary
var mouse_start_point:Vector2
var is_anim_finished:bool = false
var is_all_setup:bool = false
var is_in_guide:bool =false
var is_mousetimer_timeout:bool = true

var is_border_guide_triggered:bool = false

func _ready():
	if is_testing_level and Gl.is_debugging:
		level_start(testing_level_num)
	pass

func set_current_level_scene(value:PackedScene):
	current_level_scene = value
	current_level = current_level_scene.instance()
	current_level.name = "Level"
	add_child(current_level)
#	if $IntroLabel:
#		$IntroLabel.intro_info = current_level.intro_info
	$TimeBar.star1time = current_level.time_one_star
	$TimeBar.star2time = current_level.time_two_star
	$TimeBar.star3time = current_level.time_three_star
	$Stars.update_star_position([current_level.time_three_star,current_level.time_two_star,current_level.time_one_star])
	$Level.connect("player_start_move", self, "_on_player_start_move")
	$Level.connect("player_stop_move", self, "_on_player_stop_move")
	$Level.connect("player_into_border_zone", self, "_on_player_into_border_zone")
	connect("player_tap", $Level, "_on_player_tap")
	connect("player_stop_action", $Level, "_on_player_stop_action")
	connect("player_drag", $Level, "_on_player_drag")
	pass

func _on_player_start_move():
	if $IntroLabel:
		$IntroLabel.player_start_move()
	pass

func _on_player_stop_move():
	if $IntroLabel:
		$IntroLabel.player_stop_move()
	pass

func _on_Level_level_pass():
	var _time = $TimeBar/Time.time
	pass_state["time"] = _time
	if _time<=current_level.time_three_star:
		pass_state["star_num"] = 3
	elif _time<=current_level.time_two_star:
		pass_state["star_num"] = 2
	elif _time<=current_level.time_one_star:
		pass_state["star_num"] = 1
	else:
		pass_state["star_num"] = 0
	pass_state["lv_num"] = current_level_num
	pass_state["is_in_guide"] = is_in_guide
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
	
	is_all_setup = false
	
	var level_scene = load("res://Game/Levels/LevelScenes/"+str(level_number) +".tscn")
	if level_scene:
		set_current_level_scene(level_scene)
	else:
		set_current_level_scene(load("res://Game/Levels/LevelBase.tscn"))
	
	current_level_num = level_number
	$LevelNum.text = "Lv."+str(level_number)
	$AnimationPlayer.play("in")
	$TimeBar/Time.reset()
	if intro_info.has(level_number) and $IntroLabel:
		$IntroLabel.text = intro_info[level_number]
		$IntroLabel.intro_info = intro_info[level_number]
	yield($AnimationPlayer, "animation_finished")
	$Level.start()
	yield($Level, "level_setup_finished")
#	$TimeBar/Time.set_working(true)
	is_all_setup = true
	
	pass

func restart_level():
	#边界引导重载
	if get_node("BorderGuideLabel"):
		$BorderGuideLabel.queue_free()
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
	$Level.start()
	yield($Level, "level_setup_finished")
#	$TimeBar/Time.set_working(true)
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
#	$TimeBar/Time.set_working(true)

func _on_setting_close():
	active()
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	is_anim_finished = true
	pass # Replace with function body.

func _on_AnimationPlayer_animation_started(anim_name):
	is_anim_finished = false
	pass # Replace with function body.

func _on_player_into_border_zone():
	if GlPlayer.is_border_guide_triggered:
		return
	else:
		if !is_border_guide_triggered:
			is_border_guide_triggered = true
			var _label = Gl.BORDER_GUIDE_LINE.instance()
			add_child(_label)
			_label.name = "BorderGuideLabel"
			$Level.connect("player_into_border_zone", _label, "player_into_border_zone")
			$Level.connect("player_out_border_zone", _label, "player_out_border_zone")
#			$Level.raise()
		pass
	pass

func _input(event):
#	Gl._print(event)
	if !is_all_setup:
		return 
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:#如果左键点击
		if event.pressed:
			if is_mousetimer_timeout:
				#那么设置个时间
				mouse_start_point = get_global_mouse_position()
				is_mousetimer_timeout = false
				$MouseTimer.wait_time = slide_wait_time
				$MouseTimer.start()
				Gl._print("鼠标时间开始！")
		else:
			Gl._print("玩家离开屏幕！")
			emit_signal("player_stop_action")
			$MouseTimer.stop()
			is_mousetimer_timeout = true
		pass
	if event is InputEventMouseMotion and !$MouseTimer.is_stopped():
#		Gl._print(event)
		if event.speed.length()>= slide_speed: # and event.speed.x>0:  #向右滑动
			Gl._print("玩家开始滑动！")
			$MouseTimer.stop()
			emit_signal("player_drag", mouse_start_point)
			is_mousetimer_timeout = true
		pass
	
	pass

func _on_MouseTimer_timeout():
	Gl._print("玩家点击屏幕！")
	emit_signal("player_tap")
	pass # Replace with function body.

