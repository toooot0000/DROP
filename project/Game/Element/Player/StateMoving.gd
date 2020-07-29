extends State

func update_state(dt)->void:
	var _plus = Vector2(sin(deg2rad(owner.rect_rotation)), -cos(deg2rad(owner.rect_rotation)))*dt*owner.moving_speed*owner.rect_size
#	print(_plus)
	owner.rect_position += _plus

func _unhandled_input(event):
	if event is InputEventMouseButton and !event.pressed:
		on_player_left()
	if event is InputEventScreenTouch and !event.pressed:
		on_player_left()


func on_player_left():
	change_state("Idle")
	pass
