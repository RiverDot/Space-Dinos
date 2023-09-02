extends Node2D

@export
var money_value = 1;

func _on_area_2d_body_entered(body):
	print("Money Collected")
	#Call function on Body or emit signal
	#Play Sound
	#Spawn Particles
	queue_free()
