extends Camera2D
class_name SlideCamera2D

export(float, 0.2, 0.8, 0.05)var ground_move_speed = 0.5
#export(float, 0.8, 1, 0.05)var ground_move_margin = 0.9
export(float, 0.3, 1, 0.002)var ground_move_attenuation = 0.95
export(NodePath)var viewport_path = null
export(Rect2)var margin = Rect2(0,0,0,0) setget set_margin

onready var _is_drag = false
onready var viewport:Viewport = get_node(viewport_path)
onready var limit_center = Vector2((limit_right+limit_left)/2, (limit_top+limit_bottom)/2)

signal position_changed(position)
signal is_dragged

func set_margin(value:Rect2):
	if !viewport:
		return
	var xy = Gl.clamp_vector2(value.position, Vector2(limit_left, limit_top), Vector2(limit_right, limit_bottom)-viewport.size)
	var wh = Gl.clamp_vector2(value.size, Vector2(limit_left, limit_top) + viewport.size, Vector2(limit_right, limit_bottom))
	margin = Rect2(xy, wh)

func _process(delta):
	var dis = get_distance_to_margin()
	if dis != Vector2.ZERO:
		move(dis*ground_move_attenuation)
	pass

func move(_position_change:Vector2):
	set_position(position + _position_change)
#	clamp_position()
#	emit_signal("position_changed", position)

func set_position(value:Vector2):
	position = value
	clamp_position()
	emit_signal("position_changed", position)

func clamp_position():
	var _x_min
	var _x_max
	var _y_min
	var _y_max
	match anchor_mode:
		ANCHOR_MODE_DRAG_CENTER:
			_x_min = limit_left+viewport.size.x*zoom.x/2
			_x_max = limit_right-viewport.size.x*zoom.x/2
			_y_min = limit_top+viewport.size.y*zoom.y/2
			_y_max = limit_bottom-viewport.size.y*zoom.y/2
		ANCHOR_MODE_FIXED_TOP_LEFT:
			_x_min = limit_left
			_x_max = limit_right-viewport.size.x*zoom.x
			_y_min = limit_top
			_y_max = limit_bottom-viewport.size.y*zoom.y
	position.x = clamp(position.x, _x_min, _x_max)
	position.y = clamp(position.y, _y_min, _y_max)

func get_center_point()->Vector2:
	match anchor_mode:
		ANCHOR_MODE_DRAG_CENTER:
			return position
		ANCHOR_MODE_FIXED_TOP_LEFT:
			return position+viewport.size*zoom/2
	return Vector2.ZERO

func is_meeting_margin()->bool:
	var topleft = get_center_point()-viewport.size*zoom/2
	var downright = get_center_point()+viewport.size*zoom/2
#	return topleft.x<=limit_left*ground_move_margin or topleft.y<=limit_top*ground_move_margin or downright.x>=limit_right*ground_move_margin or downright.y>=limit_bottom*ground_move_margin
	var xy = margin.position
	var wh = margin.size
	return topleft.x<xy.x or topleft.y<xy.y or downright.x>wh.x or downright.y>wh.y

func get_topleft_point()->Vector2:
	match anchor_mode:
		ANCHOR_MODE_DRAG_CENTER:
			return position-viewport.size*zoom/2
		ANCHOR_MODE_FIXED_TOP_LEFT:
			return position
	return Vector2.ZERO

func get_margin_center()->Vector2:
	return (margin.position+margin.size)/2

func get_distance_to_margin()->Vector2:
	var dis = Vector2.ZERO
	var lt = get_center_point()-viewport.size*zoom/2
	var rb = get_center_point()+viewport.size*zoom/2
	var m_lt = margin.position
	var m_rb = margin.size
	var m_c = get_margin_center()
	var c = get_center_point()
	var dis_y = 0
	var dis_x = 0
	if (m_lt.y-lt.y)*(m_rb.y-rb.y)>0:
		dis_y = sign(m_lt.y - lt.y) * min(abs(m_lt.y - lt.y), abs(m_rb.y - rb.y))
	if (m_lt.x-lt.x)*(m_rb.x-rb.x)>0:
		dis_x = sign(m_lt.x - lt.x) * min(abs(m_lt.x - lt.x), abs(m_rb.x - rb.x))
	dis = Vector2(dis_x, dis_y)
	return dis
#	return (m_c - c).project(dis)
#	return dis.project(m_c-c)
