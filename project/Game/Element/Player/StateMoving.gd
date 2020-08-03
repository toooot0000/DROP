extends State

func update_state(dt)->void:
	if !owner.is_movable:
		change_state("Idle")
	var _plus = Vector2(sin(owner.rotation), -cos(owner.rotation))*dt*owner.moving_speed
#	print(_plus)
	owner.position += _plus

func _unhandled_input(event):
	if event is InputEventMouseButton and !event.pressed:
		on_player_left()
	if event is InputEventScreenTouch and !event.pressed:
		on_player_left()


func on_player_left():
	change_state("Idle")
	pass
