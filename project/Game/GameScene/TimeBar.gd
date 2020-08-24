extends Control

const BAR_MIN_LEN = 0
const BAR_MAX_LEN = 1000

var star1time:float
var star2time:float
var star3time:float
#var bar_init_size:Vector2

func _ready():
#	bar_init_size = $Bar.rect_size
	pass

func _process(delta):
	if star1time>0:
		$Bar.rect_size.x = lerp(BAR_MIN_LEN, BAR_MAX_LEN, 1 - $Time.time/(star1time+star2time+star3time))# clamp(BAR_MAX_LEN - $Time.time/(star1time+star2time)*(BAR_MAX_LEN-BAR_MIN_LEN), BAR_MIN_LEN, BAR_MAX_LEN)
	pass
