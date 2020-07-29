extends Node

class_name FSM,"res://Ext/FSM/icon_FSM.png"

signal change_state(from, to)

#初始状态
export(NodePath)var states_parent_node_path
export(NodePath)var ini_state_path 
export(bool)var is_active = true setget set_active
export(bool)var is_physics = true setget set_physics
export(bool)var is_debugging = false setget set_debug
export(String, FILE)var State_gd_path = ""

onready var current_state = null setget change_state
onready var state_dic:Dictionary = {}
onready var state_stack:Array = [null, ] 
onready var states = get_node(states_parent_node_path).get_children()

var _first_update = false

func _ini_state_dic():
	for state in states:
		state_dic[state.name] = state
		if !state.is_connected("change_state_to", self, "change_state"):
			state.connect("change_state_to", self, "change_state") 
	pass

""" 
赋予一个初始状态，如果没有指定初始状态，则将
"""

func _ready():
	if is_debugging:
		print(name + "FSM启动")
	
	set_process(is_active)
	set_physics_process(is_physics)
	set_debug(is_debugging)
	_ini_state_dic()
	for state in states:
		state.fsm = self
	
	if !ini_state_path:
		print("未设定初始状态！")
		var _state = load(State_gd_path).new()
		_state.name = "_State"
		add_child(_state, false)
		state_dic["_State"] = _state
		change_state(_state.name)
		print("设置默认状态为："+str(current_state.name))
	else:
		change_state(get_node(ini_state_path).name)
		if is_debugging:
			print(name + "已设定初始状态为：" + str(current_state.name))
	pass

func _process(dt):
	if !_first_update:
		if is_debugging:
			print("当前状态: "+ str(current_state.name))
		_first_update = true
	current_state._update_state(dt)
	pass

func _physics_process(dt):
	current_state._update_state_physics(dt)
	pass

func _unhandled_input(event):
	current_state._unhandled_input(event)
	pass

func change_state(target_state_name):
	var target_state = state_dic[target_state_name]
	assert(target_state)
	if !current_state:#原来是空状态
		current_state = target_state
		current_state._enter_state(null)
	else:#原来不是空状态
		current_state._exit_state(target_state)
		var pre_state = current_state
		current_state = target_state
		current_state._enter_state(pre_state)
	state_stack.append(current_state)#空状态的时候state_stack长度
	var from_name = ""
	if state_stack[-2] is Node:
		from_name = state_stack[-2].name
	var to_name = ""
	if current_state is Node:
		to_name = current_state.name
	emit_signal("change_state", from_name, to_name)
	_first_update = false
	pass

func set_active(value):
	if is_debugging:
		print("设置active为"+str(value))
	is_active = value
	set_process(value)
	if !value:
		state_stack = []
		set_physics(false)
	else:
		if current_state:
			state_stack = [null, current_state.name, ]
		else:
			state_stack = [null, ]

func set_physics(value):
	set_physics_process(value)
	is_physics = value

func set_debug(value):
	is_debugging = value
	if states:
		for state in states:
			state.is_debugging = value

func get_state(state_name:String):
	if state_name in state_dic.keys():
		return state_dic[state_name]
	else:
		assert(false)
