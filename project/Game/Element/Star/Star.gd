extends Sprite

signal player_touch_star(_self)
signal enemy_touch_star(_self, inst)

var polygon setget ,get_polygon

func get_polygon():
	return $Area2D/CollisionPolygon2D.polygon

func _ready():
	add_to_group("Star")
	connect("player_touch_star", get_parent(), "_on_Star_player_touch_star")
	connect("enemy_touch_star", get_parent(), "_on_Star_enemy_touch_star")

func _on_Area2D_area_entered(area):
	if area.owner.name == "Player":
		emit_signal("player_touch_block", self)
	else:
		emit_signal("enemy_touch_block", self, area.owner)
	pass


