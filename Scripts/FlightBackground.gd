extends Node2D

func _physics_process(delta):
	position = Vector2(0, get_parent().scroll_amount)
