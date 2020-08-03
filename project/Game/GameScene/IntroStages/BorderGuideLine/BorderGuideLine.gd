extends Label

var is_player_into_border_zone:bool = true
var is_processed:bool = false
var is_show:bool = false

func _ready():
#	$Timer.start()
	modulate.a = 0
	pass

func _process(delta):
	if is_player_into_border_zone:
		if !$AnimationPlayer.is_playing() and !is_processed and !is_show:
			is_processed = true
			is_show = true
			text = "Touch borders will reset level"
			$Timer.start()
			$AnimationPlayer.play("in")
	pass

func _on_Timer_timeout():
	$AnimationPlayer.play("out")
	is_show = false
#	is_processed = true
	pass # Replace with function body.

func player_into_border_zone():
	is_player_into_border_zone = true
	is_processed = false
	pass

func player_out_border_zone():
	is_player_into_border_zone = false
	pass

func reset():
	is_player_into_border_zone = false
	is_processed = true
	is_show = false
	$AnimationPlayer.stop()
	modulate.a = 0
