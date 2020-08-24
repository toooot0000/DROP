extends State

var drag_speed
var start_point


func on_player_left():
	owner.emit_signal("stop_move")
	change_state("Idle")
	pass


#func enter_state(from):
#	start_point = owner.get_global_mouse_position()
#	pass

func _on_Player_player_stop_action():
	on_player_left()
	pass # Replace with function body.

func update_state(dt)->void:
	if !owner.is_movable:
		change_state("Idle")
	var dis = (owner.get_global_mouse_position()-start_point)
	var spd = clamp((dis.length()/500), 0, 1)*owner.rotation_speed*sign(dis.x)
	owner.rotation+=deg2rad(spd*dt*sign((int(owner.is_clockwise)-0.5)))
#	print(_plus)
#	owner.position += _plus
