extends Control

var is_anim_finished:bool = false
var lv_num:int = 1


signal next(lv_num)
signal replay(lv_num)
signal call_back(inst)
signal call_setting


func set_pass_state(pass_state:Dictionary):
	$Stars.num = pass_state["star_num"]
	$Time.time = pass_state["time"]
	$AnimationPlayer.play("in")
	lv_num = pass_state["lv_num"]
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
