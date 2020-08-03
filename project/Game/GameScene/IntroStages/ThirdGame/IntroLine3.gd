extends Label

export(String)var intro_info = ""


var is_player_moving:bool = false
var is_processed:bool = true

func _ready():
	$Timer.start()
	modulate.a = 1

func _process(delta):
	if is_player_moving:
		if !is_processed and (!$AnimationPlayer.is_playing() or $AnimationPlayer.current_animation == "idle"):
			is_processed = true
			$AnimationPlayer.play("out")
			yield($AnimationPlayer, "animation_finished")
			text = ""
			$Timer.stop()
			$AnimationPlayer.play("in")
	else:
		if !is_processed and !$AnimationPlayer.is_playing():
			is_processed = true
			$AnimationPlayer.play("out")
			yield($AnimationPlayer, "animation_finished")
			text = intro_info
			$Timer.start()
			$AnimationPlayer.play("in")
			pass
	pass

func _on_Timer_timeout():
	$AnimationPlayer.play("idle")
	pass # Replace with function body.

func player_start_move():
	is_player_moving = true
	is_processed = false
	pass

func player_stop_move():
	is_player_moving = false
	is_processed = false
	pass
