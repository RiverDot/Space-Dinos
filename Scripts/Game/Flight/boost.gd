extends Node2D

enum Boost_Type {speed, shield}
var picked_up = false;

const PARTICLE_RESOURCE = preload("res://Nodes/Game/pick_ups/pick_up_particles.tscn")

func _on_area_2d_body_entered(_body):
	if !_body.is_in_group("Part") || picked_up:
		return
	print("Boost ship")
	get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/boost-100537.mp3"), 0)
	var particles = PARTICLE_RESOURCE.instantiate()
	get_parent().add_child(particles)
	particles.transform = transform
	get_tree().get_first_node_in_group("PlayerShip")._boost()
	queue_free()

func _on_area_2d_area_entered(area):
	if "Right_Border_Area" in area.name or "Bottom_Border_Area" in area.name or "Lef_Border_Area" in area.name:
		queue_free()
