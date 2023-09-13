extends Node2D

class_name Obstacle

var rng = RandomNumberGenerator.new()
@export
var damage_value = 1;
@export
var movementVector = Vector2(0,0)
var maxXSpeed
var minXSpeed
var maxYSpeed
var minYSpeed
var spawnPoint

var done_damage = false

func _on_area_2d_body_entered(_body):
	if _body.is_in_group("Part") && !done_damage:
		done_damage = true
		print("boom boom")
		_body._damage(damage_value)
		# Explosion Animation
		get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/medium-explosion-40472.mp3"), 0)
		# Damage Ship
		queue_free()

func _on_area_2d_area_entered(area):
	if "Right_Border_Area" in area.name or "Bottom_Border_Area" in area.name or "Lef_Border_Area" in area.name:
		queue_free()
