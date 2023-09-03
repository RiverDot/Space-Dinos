extends Node2D

@export
var money_value = 1;

const PARTICLE_RESOURCE = preload("res://Nodes/pick_ups/pick_up_particles.tscn")

func _on_area_2d_body_entered(_body):
	print("Money Collected")
	#Call function on Body or emit signal
	get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/ping.mp3"), 0)
	var particles = PARTICLE_RESOURCE.instantiate()
	particles.transform = transform
	get_parent().add_child(particles)
	queue_free()
