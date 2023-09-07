extends Node2D

@export
var damage_value = 1;
@export
var movementVector = Vector2(0,0)

func _process(_delta):
	translate(movementVector)

func _on_area_2d_body_entered(_body):
	if  "Rocket Ship" in _body.name:
		print("boom boom")
		# Explosion Animation
		get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/ping.mp3"), 0)
		# Damage Ship
		queue_free()
