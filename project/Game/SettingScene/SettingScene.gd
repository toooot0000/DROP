extends Control

signal setting_close



func _ready():
	$CenterContainer/Bg/Bar1/TextureRect.set_circle_position(GlPlayer.music_volume)
	$CenterContainer/Bg/Bar2/TextureRect.set_circle_position(GlPlayer.effect_volume)
	$AnimationPlayer.play("in")


func _on_CloseButton_button_down():
	GlPlayer.save()
	$AnimationPlayer.play("out")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("setting_close")
	pass # Replace with function body.
