extends Sprite

signal player_touch_block(_self)
signal enemy_touch_block(_self, inst)

var polygon setget ,get_polygon

func get_polygon():
	return $Area2D/CollisionPolygon2D.polygon

func _ready():
	add_to_group("Block")
	connect("player_touch_block", get_parent(), "_on_Block_player_touch_block")
	connect("enemy_touch_block", get_parent(), "_on_Block_enemy_touch_block")

func _on_Area2D_area_entered(area):
	if area.owner.name == "Player":
		emit_signal("player_touch_block", self)
	else:
		emit_signal("enemy_touch_block", self, area.owner)
	pass



