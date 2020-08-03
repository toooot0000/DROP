extends Sprite

enum TYPE{UP, LEFT, RIGHT, DOWN}

export(float)var distance = 300
export(TYPE)var type

var player_in_border_zone:bool = false

func _process(delta):
	var _player = get_tree().get_nodes_in_group("Player")
	var _enemy = get_tree().get_nodes_in_group("Enemy")
	var arr = Gl.array_link(_player, _enemy)
	
	match type:
		TYPE.UP:
			var _n = arr[0]
			for node in arr:
				if node.center_point.y<_n.center_point.y:
					_n = node
				pass
			modulate.a = 1 - (abs(_n.center_point.y - position.y)-200)/distance
			pass
		TYPE.DOWN:
			var _n = arr[0]
			for node in arr:
				if node.center_point.y>_n.center_point.y:
					_n = node
				pass
			modulate.a = 1 - (abs(_n.center_point.y - position.y)-200)/distance
			pass
		TYPE.LEFT:
			var _n = arr[0]
			for node in arr:
				if node.center_point.x<_n.center_point.x:
					_n = node
				pass
			modulate.a = 1 - (abs(_n.center_point.x - position.x)-200)/distance
			pass
		TYPE.RIGHT:
			var _n = arr[0]
			for node in arr:
				if node.center_point.x>_n.center_point.x:
					_n = node
				pass
			modulate.a = 1 - (abs(_n.center_point.x - position.x)-200)/distance
			pass
	
	if player_in_border_zone:
		if modulate.a <0.01:
			player_in_border_zone = false
			owner.emit_signal("player_out_border_zone")
	
	elif modulate.a>0.01:
		owner.emit_signal("player_into_border_zone")
		player_in_border_zone = true
		pass
	
	pass
