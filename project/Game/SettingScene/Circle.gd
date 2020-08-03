extends TextureButton

var is_holding:bool = false
var value:float

export(float)var max_x = 360
export(float)var min_x = -10
export(int, 'MUSIC', 'EFFECT')var type

#signal change_value(value)


func _on_TextureRect_button_down():
	is_holding = true
	pass # Replace with function body.


func _on_TextureRect_button_up():
	is_holding = false
	pass # Replace with function body.


func _process(delta):
	if is_holding:
		rect_position.x += get_local_mouse_position().x
		rect_position.x = clamp(rect_position.x, min_x, max_x)
		var value = (rect_position.x-min_x)/(max_x-min_x)
		match type:
			0:
				GlPlayer.set_music_volume(value)
				pass
			1:
				GlPlayer.set_effect_volume(value)
				pass
		pass
	pass


func set_circle_position(value:float):
	rect_position.x = value*(max_x - min_x) + min_x
	pass
