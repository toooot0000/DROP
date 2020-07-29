extends TextureButton




func _on_Start_button_down():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("button_pressed")
	$Tween.interpolate_property(self, "rect_position", rect_position+0.1*rect_size, rect_position, 0.1)
	$Tween.start()
	pass
