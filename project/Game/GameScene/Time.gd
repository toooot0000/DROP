extends Label

var time:float = 0
var is_working:bool = false setget set_working
#func _ready():
#	text = "{0}:{1}".format([int(time)/60, time-int(time)/60*60])

func _process(delta):
	if is_working:
		time+=delta
		text = "{0}:{1}".format([int(time)/60, floor(time-int(time)/60*60)])
	pass

func _ready():
	owner.connect("player_drag", self, "_on_GameScene_player_drag")
	owner.connect("player_stop_action", self, "_on_GameScene_player_stop_action")
	owner.connect("player_tap", self, "_on_GameScene_player_tap")
	pass

func reset():
	time = 0
	is_working = false
	text = "{0}:{1}".format([int(time)/60, floor(time-int(time)/60*60)])

func set_working(value:bool):
	is_working = value


func _on_GameScene_player_drag(mouse_point):
	is_working = true
	pass # Replace with function body.


func _on_GameScene_player_stop_action():
	is_working = false
	pass # Replace with function body.


func _on_GameScene_player_tap():
	is_working = true
	pass # Replace with function body.
