extends Viewport
class_name SlideViewport

signal position_changed(position)

var limit_top = -10000
var limit_bottom = 10000
var limit_left = -10000
var limit_right = 10000
# left, top, right, bottom
export(Rect2)var margin setget set_margin
export(Rect2)var margin_distance setget set_margin_distance
export(float, 0.2, 0.8, 0.05)var ground_move_speed = 0.5
export(float, 5, 20, 0.05)var ground_move_keyboard_speed = 10
#export(float, 0.8, 1, 0.005)var ground_move_margin = 0.9
export(float, 0.3, 1, 0.002)var ground_move_attenuation = 0.95

export(NodePath)var margin_change_control

var _is_drag:bool = false
var is_working:bool = false setget set_working
var _position_change:Vector2

func set_margin(value:Rect2):
	margin = value
	update_camera_limit()

func set_margin_distance(value):
	margin_distance = value
	update_camera_limit()

func update_camera_limit():
	var lt = margin.position
	var rb = margin.size
	var _lt = margin_distance.position
	var _rb = margin_distance.position
	limit_top = lt.y - _lt.y
	limit_left = lt.x - _lt.x
	limit_right = max(rb.x + _rb.x, limit_left+size.x)
	limit_bottom = max(rb.y + _rb.y, limit_top+size.y)
	$Camera2D.limit_top = limit_top
	$Camera2D.limit_bottom = limit_bottom
	$Camera2D.limit_left = limit_left
	$Camera2D.limit_right = limit_right
	$Camera2D.margin = margin
	$Camera2D.limit_center = Vector2((limit_right+limit_left)/2, (limit_top+limit_bottom)/2)

func _ready():
	get_parent().slide_viewport = self
	update_camera_limit()
	$Camera2D.ground_move_attenuation = ground_move_attenuation
	if margin_change_control and get_node(margin_change_control) is Control:
		get_node(margin_change_control).connect("resized", self, "_on_margin_change_control_resized")
		pass

func _process(delta):
	if _position_change != Vector2.ZERO and is_working:
		$Camera2D.move(_position_change)
		_position_change = Vector2.ZERO

func _unhandled_input(event:InputEvent):
	var _xx = int(event.is_action("ui_right"))-int(event.is_action("ui_left"))
	var _yy = int(event.is_action("ui_down"))-int(event.is_action("ui_up"))
	if _xx != 0 or _yy != 0:
		_position_change = Vector2(_xx, _yy).normalized()*ground_move_keyboard_speed
	pass

func _input(event):
	if event is InputEventMouseButton and is_working:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				_is_drag = true
			else:
				_is_drag = false
	if event is InputEventMouseMotion and _is_drag and is_working:
		_position_change = -event.relative*ground_move_speed

func set_working(value:bool):
	is_working = value
	$Camera2D.current = value
	pass

func _on_Camera2D_position_changed(position:Vector2):
	emit_signal("position_changed", position)
	pass

func get_position_value()->Vector2:
	var position = $Camera2D.get_topleft_point()
	var vec:Vector2
	vec = (position - margin.position)/(margin.size - margin.position - size)*100
#	vec = (position-Vector2(limit_left, limit_top)*ground_move_margin)/(Vector2(limit_right*ground_move_margin-size.x, limit_bottom*ground_move_margin-size.y)-Vector2(limit_left, limit_top)*ground_move_margin)*100
	return vec

func _on_margin_change_control_resized():
	self.margin = Rect2(get_node(margin_change_control).rect_position, get_node(margin_change_control).rect_position+get_node(margin_change_control).rect_size)
	pass



