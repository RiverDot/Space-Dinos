extends Node2D

@export var height: float = 0.0
@export var height_multiplier: float = 5.0
@export var scroll_amount: float

func _process(_delta):
	scroll_amount = height * height_multiplier
