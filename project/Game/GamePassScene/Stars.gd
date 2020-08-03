extends HBoxContainer


var num:int = 1 setget set_num


func set_num(value:int):
	num = value
	for i in range(3 - num):
		get_child(i).hide()
	
	
