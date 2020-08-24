extends Sprite

export(float) var acc_spd = 50
export(float) var acc_ang_spd = 10

var polygon setget ,get_polygon
var is_anim_finished:bool = false

func _ready():
	add_to_group("Accelerator")
	pass

func get_polygon():
	return $Area2D/CollisionPolygon2D.polygon

func _on_Area2D_area_entered(area):
	if !is_anim_finished:
		
		area.owner.moving_speed += acc_spd
		area.owner.rotation_speed += acc_ang_spd
		
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
