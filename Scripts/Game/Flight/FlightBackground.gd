extends Node2D

func _physics_process(_delta):
	pass
	position += Vector2(0, get_parent().scroll_amount)
