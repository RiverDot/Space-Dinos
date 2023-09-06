extends StaticBody2D

class_name PartBase

var id: int

var value: int

var height: int

var width: int

func _setup(part: Part):
	id = part.id
	value = part.cost

	height = 1
	width = 1