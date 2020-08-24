extends Control

var positions:Array = []

func _ready():
	for child in get_children():
		positions.append(child.rect_position)


func update_star_position(times:Array=[1, 2, 3]):
	
	$Star1.rect_position = lerp(positions[2], positions[0], (times[0])/(times[1]+times[0]+times[2])) - Vector2(20, 0)
	$Star2.rect_position = lerp(positions[2], positions[0], (times[1])/(times[1]+times[0]+times[2])) - Vector2(20, 0)
	$Star3.rect_position = lerp(positions[2], positions[0], (times[2])/(times[1]+times[0]+times[2])) - Vector2(20, 0)
	#(times[1]-times[0])/(times[2]-times[0])*(positions[2]-positions[0])+positions[0]
	pass
