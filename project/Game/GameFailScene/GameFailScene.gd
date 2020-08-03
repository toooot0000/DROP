extends Control

var is_anim_finished:bool = false
var lv_num:int = 1


signal next(lv_num)
signal replay(lv_num)
signal call_back(inst)
signal call_setting


func set_fail_type(type:int, _lv_num:int):
	match type:
		Gl.FAIL_TYPE.PLAYER_TOUCH_BLOCK:
			$Screen.texture = load("res://Asset/Pic/bg_red.png")
		Gl.FAIL_TYPE.ENEMY_TOUCH_PLAYER, Gl.FAIL_TYPE.ENEMY_TOUCH_TARGET:
			$Screen.texture = load("res://Asset/Pic/bg_gray_6e6e6e.png")
	$AnimationPlayer.play("in")
	lv_num = _lv_num
	pass

func _on_NextButton_button_down():
	if is_anim_finished:
		$AnimationPlayer.play("out")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("next", lv_num)
		pass
	pass

func _on_ReplayButton_button_down():
	if is_anim_finished:
		$AnimationPlayer.play("out")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("replay", lv_num)
		pass
	pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(anim_name):
	is_anim_finished = true
	pass # Replace with function body.

func _on_AnimationPlayer_animation_started(anim_name):
	is_anim_finished = false
	pass # Replace with function body.

func _on_Back_button_down():
	$AnimationPlayer.play("out")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("call_back", self)
	pass # Replace with function body.

func _on_Setting_button_down():
	if is_anim_finished:
		emit_signal("call_setting")
	pass # Replace with function body.

func _on_setting_close():
	pass
