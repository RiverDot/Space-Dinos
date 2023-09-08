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

func _on_area_2d_area_entered(area):
	if "Right_Border_Area" in area.name or "Bottom_Border_Area" in area.name or "Lef_Border_Area" in area.name:
		queue_free()
