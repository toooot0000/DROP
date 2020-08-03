extends Sprite

enum TYPE{UP, LEFT, RIGHT, DOWN}

export(float)var distance = 300
export(TYPE)var type

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
	
#	var _n = arr[0]
#	for node in arr:
#		if node.y>_n.y:
#			_n = node
#		pass
#	modulate.a = 1 - (abs(get_node("../../Player").center_point.y - position.y)-200)/distance
#	modulate.a = 1 - (abs(get_node("../../Player").center_point.x - position.x)-200)/distance
	pass
