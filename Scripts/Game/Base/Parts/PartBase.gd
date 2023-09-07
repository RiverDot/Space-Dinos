extends StaticBody2D

class_name PartBase

var id: int

var value: int

var height: int

var width: int

var grid_pos: Vector2

func _setup(part: Part):
	id = part.id
	value = part.cost

	height = 1
	width = 1

func _get_sprite():
	return $Sprite