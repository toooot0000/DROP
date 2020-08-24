extends State


func update_state(dt:float)->void:
#	if !owner.is_movable:
#		return 
#	owner.rotation+=deg2rad(owner.rotation_speed*dt*sign((int(owner.is_clockwise)-0.5)))
	pass

func _unhandled_input(event):
#	if !is_current_state():
#		return
#	if !owner.is_movable:
#		return 
##	print(event)
#	if event is InputEventMouseButton and event.pressed:
#		on_player_tap()
#	if event is InputEventScreenTouch and event.pressed:
#		on_player_tap()
	pass

func on_player_tap():
#	print("tap")
	change_state("Moving")
	owner.emit_signal("start_move")
	pass

func _on_Player_player_tap():
	if !is_current_state():
		return
	if !owner.is_movable:
		return 
	on_player_tap()
	pass # Replace with function body.


func _on_Player_player_drag(mouse_point):
	if !is_current_state():
		return
	if !owner.is_movable:
		return 
	change_state("Spining")
	$"../Spining".start_point = mouse_point
	pass # Replace with function body.
