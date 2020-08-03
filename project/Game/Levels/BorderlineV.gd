extends Sprite

export(float)var distance = 300

func _process(delta):
	var _player = get_tree().get_nodes_in_group("Player")
	var _enemy = get_tree().get_nodes_in_group("Enemy")
	var arr = Gl.array_link(_player, _enemy)
	
	modulate.a = 1 - (abs(get_node("../../Player").center_point.x - position.x)-200)/distance
	pass
