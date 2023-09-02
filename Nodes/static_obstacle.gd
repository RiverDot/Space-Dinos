extends Node2D

@export
var damage_value = 1;

func _on_area_2d_body_entered(body):
	print("boom boom")
	# Explosion
	# Damage Ship
	queue_free()
