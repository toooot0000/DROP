extends Control
class_name Level


signal level_pass
signal level_fail(type)
signal level_restart
signal level_setup_finished

signal player_into_border_zone
signal player_out_border_zone

signal player_drag(mouse_point)
signal player_tap
signal player_stop_action

enum TARGET_TYPE{TARGET, ALL_ENEMY}

export(TARGET_TYPE)var target_type 
export(float)var time_one_star
export(float)var time_two_star
export(float)var time_three_star
#export(String)var intro_info = "" 

#var is_anim_finished:bool = false

var target_num:float = 0

func _ready():
	modulate.a = 0
	connect("level_fail", get_parent(), "_on_Level_level_fail")
	connect("level_pass", get_parent(), "_on_Level_level_pass")
	connect("level_restart", get_parent(), "_on_Level_level_restart")
	
	$Player.is_movable = false
	get_tree().call_group("Enemy", "set_movable", false)
#	target_num = get_tree().get_nodes_in_group("Target").size()
	
	
	pass

func start():
	$AnimationPlayer.play("level_start")
	yield($AnimationPlayer, "animation_finished")
	$Player.is_movable = true
	get_tree().call_group("Enemy", "set_movable", true)
	emit_signal("level_setup_finished")

func player_hit_border():
	print("Player hit border!")
	emit_signal("level_restart")
	$Player.is_movable = false
	get_tree().call_group("Enemy", "set_movable", false)
	pass

func _on_Target_player_touch_target(inst):
	if $AnimationPlayer.is_playing():
		return
	target_num-=1
	if target_num>0:
		inst.disappear()
		return 
	print("Player Touch Target")
	get_tree().call_group("Enemy", "set_movable", false)
	$Player.is_movable = false
	$Polygon2D.position = inst.position
	$Polygon2D.polygon = inst.polygon
	$Polygon2D.show()
	$Polygon2D.color = Gl.GREEN
	$AnimationPlayer.play("level_clear")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("level_pass")
	pass # Replace with function body.

func _on_Target_enemy_touch_target(inst):
	if $AnimationPlayer.is_playing():
		return
	print("Enemy Touch Target")
	get_tree().call_group("Enemy", "set_movable", false)
	$Player.is_movable = false
	$Polygon2D.position = inst.position
	$Polygon2D.polygon = inst.polygon
	$Polygon2D.show()
	$Polygon2D.color = Gl.GRAY
	$AnimationPlayer.play("level_clear")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("level_fail", Gl.FAIL_TYPE.ENEMY_TOUCH_TARGET)
	pass # Replace with function body.

func _on_Player_touched_by_enemy():
	if $AnimationPlayer.is_playing():
		return
	print("Enemy Touch Player")
	get_tree().call_group("Enemy", "set_movable", false)
	$Player.is_movable = false
	$Polygon2D.position = $Player.position
	$Polygon2D.offset = $Player.polygon_offset
	$Polygon2D.rotation = $Player.rotation
	$Polygon2D.polygon = $Player.polygon
	$Polygon2D.show()
	$Polygon2D.color = Gl.GRAY
	$AnimationPlayer.play("level_clear")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("level_fail", Gl.FAIL_TYPE.ENEMY_TOUCH_PLAYER)
	pass # Replace with function body.

func _on_Block_player_touch_block(block):
	if $AnimationPlayer.is_playing():
		return
	print("Player Touch Block")
	get_tree().call_group("Enemy", "set_movable", false)
	$Player.is_movable = false
	$Polygon2D.position = block.position
	$Polygon2D.polygon = block.polygon
	$Polygon2D.show()
	$Polygon2D.color = Gl.RED
	$AnimationPlayer.play("level_clear")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("level_fail", Gl.FAIL_TYPE.PLAYER_TOUCH_BLOCK)
	pass

#暂时没用
func _on_Block_enemy_touch_block(block, enemy):
	pass

func _on_Enemy_enemy_touch_border(enemy):
	emit_signal("level_restart")
	$Player.is_movable = false
	get_tree().call_group("Enemy", "set_movable", false)
	pass

func _on_Player_player_touch_border():
	player_hit_border()
	pass # Replace with function body.

func freeze():
	$Player.is_movable = false
	get_tree().call_group("Enemy", "set_movable", false)
	pass

func active():
	$Player.is_movable = true
	get_tree().call_group("Enemy", "set_movable", true)
	pass

func _on_player_tap():
	emit_signal("player_tap")
	pass

func _on_player_drag(mouse_point:Vector2):
	emit_signal("player_drag", mouse_point)
	pass

func _on_player_stop_action():
	emit_signal("player_stop_action")
	pass

