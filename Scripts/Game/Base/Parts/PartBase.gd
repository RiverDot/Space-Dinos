extends StaticBody2D

class_name PartBase

var id: int

var value: int

func _setup(part: Part):
	id = part.id
	value = part.cost