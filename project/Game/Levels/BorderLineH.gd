extends Sprite

export(float)var distance = 300

func _process(delta):
	modulate.a = 1 - (abs(get_node("../../Player").center_point.y - position.y)-200)/distance
	pass
