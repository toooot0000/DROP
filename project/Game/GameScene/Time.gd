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


func reset():
	time = 0
	is_working = false
	text = "{0}:{1}".format([int(time)/60, floor(time-int(time)/60*60)])

func set_working(value:bool):
	is_working = value

