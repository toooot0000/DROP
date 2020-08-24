extends Sprite

signal player_touch_target(inst)
signal enemy_touch_target(inst)

signal player_drag(speed)
signal player_tap
signal player_stop_action


var polygon setget ,get_polygon
var is_having_touched:bool = false

func get_polygon():
	return $Area2D/CollisionPolygon2D.polygon

func _ready():
	$AnimationPlayer.play("idle")
	owner.target_num+=1
	owner.connect("player_drag", self, "_on_player_drag")
	owner.connect("player_tap", self, "_on_player_tap")
	owner.connect("player_stop_action", self, "_on_player_stop_action")


func _on_Area2D_area_entered(area):
	if is_having_touched:
		return
	else:
		is_having_touched = true
	if area.owner.name == "Player":
		emit_signal("player_touch_target", self)
	else:
		emit_signal("enemy_touch_target", self)
	pass

func disappear():
	$AnimationPlayer.play("disappear")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func _on_player_tap():
	emit_signal("player_drag")
	pass

func _on_player_drag(speed:Vector2):
	emit_signal("player_drag", speed)
	pass

func _on_player_stop_action():
	emit_signal("player_stop_action")
	pass

