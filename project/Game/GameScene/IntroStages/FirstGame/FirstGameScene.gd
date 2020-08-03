extends GameScene


func _ready():
	is_in_guide = true
	level_start(1)

func set_current_level_scene(param):
	.set_current_level_scene(param)
	$Level.connect("player_start_move", self, "_on_player_start_move")
	$Level.connect("player_stop_move", self, "_on_player_stop_move")

func _on_player_start_move():
#	print("player_start_move")
	if !$Title.is_out:
		$Title/AnimationPlayer.play("out")
		$Title.is_out = true
		$PlayerFake.hide()
	$IntroLine.player_start_move()
	pass

func _on_player_stop_move():
	$IntroLine.player_stop_move()
	pass

