extends GameScene

func _ready():
	is_in_guide = true
	guide_level_start(2)


func guide_level_start(level_number:int):
	current_level_num = level_number
	is_all_setup = false
	$LevelNum.text = "Lv."+str(level_number)
	$AnimationPlayer.play("in")
	$TimeBar/Time.reset()
#	yield($AnimationPlayer, "animation_finished")
	
	var level_scene = load("res://Game/Levels/LevelScenes/"+str(level_number) +".tscn")
	if level_scene:
		set_current_level_scene(level_scene)
	else:
		set_current_level_scene(load("res://Game/Levels/LevelBase.tscn"))
	#抬一手绿幕
	$BgGreen.raise()
	yield($Level, "level_setup_finished")
	
	$TimeBar/Time.set_working(true)
	is_all_setup = true
	#链接关卡信号到边界
	$Level.connect("player_into_border_zone", self, "_on_player_into_border_zone")
	
	pass

func restart_level():
	.restart_level()
	$IntroLine.is_processed = false
	$IntroLine.is_player_moving = false

