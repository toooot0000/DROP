extends Control

const LV_NODE = preload("res://Game/LevelChooseScene/LevelNode/LevelNode.tscn")

var is_anim_finished:bool = false
var lv_num:int = 1

signal call_back(inst)
signal call_setting
signal choose_level(lv_num)

func _ready():
	var level_nums = Gl.get_all_level_num()
	for i in range(level_nums):
		var node = LV_NODE.instance()
		$GridContainer.add_child(node)
		node.set_num(i+1)
		if i<GlPlayer.current_level:
			node.set_state(node.UNLOCK)
			node.set_star_num(GlPlayer.level_states[i]["star"])
			pass
		else:
			node.set_state(node.LOCKED)
			node.set_star_num(0)
			pass
		node.connect("choose_level", self, '_on_LevelNode_choose_level')
	$AnimationPlayer.play("in")
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	is_anim_finished = true
	pass # Replace with function body.

func _on_AnimationPlayer_animation_started(anim_name):
	is_anim_finished = false
	pass # Replace with function body.

func _on_Back_button_down():
	$AnimationPlayer.play("out")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("call_back", self)
	pass # Replace with function body.

func _on_Setting_button_down():
	if is_anim_finished:
		emit_signal("call_setting")
	pass # Replace with function body.

func _on_setting_close():
	pass

func _on_LevelNode_choose_level(lv_num):
	if !is_anim_finished:
		return 
	$AnimationPlayer.play("out")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("choose_level", lv_num)
	pass

