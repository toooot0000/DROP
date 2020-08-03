extends Label

var time:float = 0 setget set_time
#var is_working:bool = false setget set_working
#func _ready():
#	text = "{0}:{1}".format([int(time)/60, time-int(time)/60*60])


func set_time(_time:float):
	time = _time
	text = "{0}:{1}".format([int(time)/60, floor(time-int(time)/60*60)])

#func _process(delta):
#	text = "{0}:{1}".format([int(time)/60, floor(time-int(time)/60*60)])
#	pass

