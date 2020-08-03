extends Sprite

var polygon setget ,get_polygon

var is_anim_finished:bool = false

func get_polygon():
	return $Area2D/CollisionPolygon2D.polygon

func _on_Area2D_area_entered(area):
	if !is_anim_finished:
		area.owner.is_clockwise = !area.owner.is_clockwise
		$AnimationPlayer.play("out")
		yield($AnimationPlayer, "animation_finished")
		queue_free()
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	is_anim_finished = true
	pass # Replace with function body.


func _on_AnimationPlayer_animation_started(anim_name):
	is_anim_finished = false
	pass # Replace with function body.
