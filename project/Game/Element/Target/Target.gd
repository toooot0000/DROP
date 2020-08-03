extends Sprite

signal player_touch_target
signal enemy_touch_target

var polygon setget ,get_polygon
var is_having_touched:bool = false

func get_polygon():
	return $Area2D/CollisionPolygon2D.polygon

func _ready():
	$AnimationPlayer.play("idle")


func _on_Area2D_area_entered(area):
	if is_having_touched:
		return
	else:
		is_having_touched = true
	if area.owner.name == "Player":
		emit_signal("player_touch_target")
	else:
		emit_signal("enemy_touch_target")
	pass



