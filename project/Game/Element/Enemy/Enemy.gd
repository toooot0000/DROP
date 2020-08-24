extends Sprite

export(float)var rotation_speed = 5
export(float)var moving_speed = 5

signal touched_by(_self, player)
signal enemy_touch_border(_self)
signal player_drag(mouse_point)
signal player_tap
signal player_stop_action
signal stop_move
signal start_move

var origin_size:Vector2 = Vector2(193, 271)
var center_point:Vector2 = Vector2.ZERO
var is_clockwise:bool = true
var is_movable:bool = true
var is_moving:bool = true setget ,get_is_moving


func get_is_moving()->bool:
	return $FSM.current_state.name == "Moving"

func _process(delta):
	center_point = position + $CenterPoint.position
	is_moving = $FSM.current_state.name == "Moving"

func _ready():
	add_to_group("Enemy")
	connect("enemy_touch_border", get_parent(), "_on_Enemy_enemy_touch_border")
	owner.connect("player_drag", self, "_on_player_drag")
	owner.connect("player_tap", self, "_on_player_tap")
	owner.connect("player_stop_action", self, "_on_player_stop_action")


func _on_player_tap():
	emit_signal("player_tap")
	pass

func _on_player_drag(mouse_point:Vector2):
	emit_signal("player_drag", mouse_point)
	pass

func _on_player_stop_action():
	emit_signal("player_stop_action")
	pass


func set_movable(value:bool):
	is_movable = value

func change_state(state_name:String):
	$FSM.change_state(state_name)
	pass

func _on_TakingBody_area_entered(area):
#	if is_moving:
	if area.owner.is_in_group("Player"):
		emit_signal("touched_by", self, area.owner)
	elif area.owner.is_in_group("Block"):
		#要加动画的！
		$AnimationPlayer.play("enemy_die")
		is_movable = false
		yield($AnimationPlayer, "animation_finished")
		queue_free()
	elif area.is_in_group("Border"):
		emit_signal("enemy_touch_border", self)
#	elif true:
#		pass
	pass
