extends Control

signal start_game
signal start_select_level
signal call_setting

var is_anim_finished:bool = false



func _ready():
	$AnimationPlayer.play("entry_in")

func _on_Start_button_down():
	if is_anim_finished:
		$AnimationPlayer.play("entry_out")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("start_game")
		queue_free()
	pass

func _on_Level_button_down():
	if is_anim_finished:
		$AnimationPlayer.play("entry_out")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("start_select_level")
		queue_free()
	pass # Replace with function body.

func _on_Setting_button_down():
	if is_anim_finished:
		emit_signal("call_setting")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	is_anim_finished = true
	pass # Replace with function body.


func _on_AnimationPlayer_animation_started(anim_name):
	is_anim_finished = false
	pass # Replace with function body.
