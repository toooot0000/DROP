extends Control


enum{UNLOCK, LOCKED}

var level_num:int
var state:int
var star_num:int

signal choose_level(level_num)

func _ready():
	set_state(UNLOCK)
	pass

func set_num(_num:int):
	level_num = _num
	$TextureRect/Label.text = str(level_num)
	pass

func set_state(value:int):
	state = value
	if state == UNLOCK:
		$TextureRect.texture_normal = load('res://Asset/Pic/frame_level_green.png')
		$TextureRect/Label.set("custom_colors/font_color", Gl.GREEN)
	else:
		$TextureRect.texture_normal = load('res://Asset/Pic/frame_level.png')
		$TextureRect/Label.set("custom_colors/font_color", Gl.LITE_GRAY)
		

func set_star_num(value):
	star_num = value
	for i in range(3 - star_num):
		$Stars.get_child(i).hide()
	pass

func _on_TextureRect_button_down():
	$AnimationPlayer.play("click")
	$AudioStreamPlayer.play()
	yield($AnimationPlayer, "animation_finished")
	if state == UNLOCK:
		emit_signal("choose_level", level_num)
	pass # Replace with function body.
