extends Node2D

@export
var money_value = 1;

func _on_area_2d_body_entered(body):
	print("Money Collected")
	#Call function on Body or emit signal
	get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/ping.mp3"), 0)
	#Spawn Particles
	queue_free()
