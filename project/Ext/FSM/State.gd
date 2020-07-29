extends Node

class_name State, "res://Ext/FSM/icon_state.png"

signal enter_from(previous_state)
signal exit_to(target_state)
# warning-ignore:unused_signal
signal change_state_to(target_state)

var _first_update = false
var fsm

export(bool)var is_debugging = false


func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	pass

# warning-ignore:unused_argument
func _unhandled_input(event):
	pass

#进入该状态
func _enter_state(previous_state:Node)->void:
	if is_debugging:
		print('-------------'+owner.name+'-------------')
		if previous_state:
			print('来自状态: '+previous_state.name)
		print("进入状态: "+name)
	emit_signal("enter_from", previous_state)
	_first_update = false
	enter_state(previous_state)
	pass

func enter_state(previous_state:Node)->void:
	pass

#状态持续中
#继承的时候需要执行下父方法
# warning-ignore:unused_argument
func _update_state(dt):
	if !_first_update:
		if is_debugging:
			print("更新状态: "+name)
		_first_update = true
		update_state_first(dt)
	update_state(dt)
	pass

func update_state(dt)->void:
	pass

func update_state_first(dt)->void:
	pass

# warning-ignore:unused_argument
func _update_state_physics(dt):
	if is_debugging:
		print("物理更新状态: "+name)
		update_state_physics_first(dt)
	update_state_physics(dt)
	pass

func update_state_physics(dt):
	pass

func update_state_physics_first(dt):
	pass

#离开该状态
func _exit_state(target_state:Node):
	if is_debugging:
		print("离开状态: "+name)
		print('目标状态: '+target_state.name)
	emit_signal("exit_to", target_state)
	exit_state(target_state)
	pass

func exit_state(target_state:Node)->void:
	pass

#判断当前状态是否是自身
func is_current_state():
#	print($"..".current_state)
#	print(self)
#	print($'..'.current_state == self)
	return fsm.current_state == self

func change_state(target_state_name:String)->void:
	emit_signal("change_state_to", target_state_name)
