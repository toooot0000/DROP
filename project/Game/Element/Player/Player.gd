extends Sprite

export(float)var rotation_speed = 5
export(float)var moving_speed = 5

signal touched_by_enemy
signal player_touch_border
signal start_move
signal stop_move

var origin_size:Vector2 = Vector2(193, 271)
var center_point:Vector2 = Vector2.ZERO

var is_clockwise:bool = true
var is_movable:bool = true
var is_moving:bool = false setget ,get_is_moving

var polygon setget ,get_polygon
var polygon_offset setget ,get_polygon_offset

func get_is_moving()->bool:
	return $FSM.current_state.name == "Moving"

func get_polygon_offset():
	return $TakingBody/CollisionPolygon2D.position

func get_polygon():
	return $TakingBody/CollisionPolygon2D.polygon

func _process(delta):
	center_point = position + $CenterPoint.position
	is_moving = $FSM.current_state.name == "Moving"


func change_state(state_name:String):
	$FSM.change_state(state_name)
	pass


func _on_TakingBody_area_entered(area):
	if is_moving:
		if area.owner.is_in_group("Enemy") and !area.owner.is_queued_for_deletion():
			emit_signal("touched_by_enemy")
		elif area.is_in_group("Border"):
			emit_signal("player_touch_border")
			pass
#		elif area.owner.is_in_group("Block"):
#			emit_signal(tou)
	pass
