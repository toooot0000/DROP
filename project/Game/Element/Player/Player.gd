extends TextureRect

export(float)var rotation_speed = 5
export(float)var moving_speed = 5

var origin_size:Vector2 = Vector2(193, 271)
var is_clockwise:bool = true

func _on_Player_resized():
	rect_pivot_offset *= (Vector2(rect_size.x, rect_size.y)/origin_size)
	origin_size = rect_size
	pass
