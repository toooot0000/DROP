extends State

func update_state(dt)->void:
	if !owner.is_movable:
		change_state("Idle")
	var _plus = Vector2(sin(owner.rotation), -cos(owner.rotation))*dt*owner.moving_speed
#	print(_plus)
	owner.position += _plus

#func _unhandled_input(event):
#	if event is InputEventMouseButton and !event.pressed:
#		on_player_left()
#	if event is InputEventScreenTouch and !event.pressed:
#		on_player_left()


func on_player_left():
	owner.emit_signal("stop_move")
	change_state("Idle")
	pass


func _on_Player_player_stop_action():
	on_player_left()
	pass # Replace with function body.
