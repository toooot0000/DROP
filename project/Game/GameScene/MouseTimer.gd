extends Timer

func _ready():
	connect("timeout", owner, "_on_MouseTimer_timeout")
