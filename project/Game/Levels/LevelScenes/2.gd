extends Level

signal player_start_move
signal player_stop_move

func _on_Player_start_move():
	emit_signal("player_start_move")
	pass # Replace with function body.


func _on_Player_stop_move():
	emit_signal("player_stop_move")
	pass 
