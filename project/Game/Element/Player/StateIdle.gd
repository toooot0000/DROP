extends State


func update_state(dt:float)->void:
	owner.rect_rotation+=owner.rotation_speed*dt
	pass

func _unhandled_input(event):
	if !is_current_state():
		return
#	print(event)
	if event is InputEventMouseButton and event.pressed:
		on_player_tap()
	if event is InputEventScreenTouch and event.pressed:
		on_player_tap()
	pass

func on_player_tap():
	print("tap")
	change_state("Moving")
	pass
