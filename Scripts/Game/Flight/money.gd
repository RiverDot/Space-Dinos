extends Node2D

@export
var money_value = 1;

const PARTICLE_RESOURCE = preload("res://Nodes/Game/pick_ups/pick_up_particles.tscn")

func _on_area_2d_body_entered(_body):
	if  "Rocket Ship" in _body.name:
		print("Boost ship")
		get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/ping.mp3"), 0)
		get_tree().get_first_node_in_group("MoneyManager")._change_money(1)
		var particles = PARTICLE_RESOURCE.instantiate()
		particles.transform = transform
		queue_free()


func _on_area_2d_area_entered(area):
	if "Right_Border_Area" in area.name or "Bottom_Border_Area" in area.name or "Lef_Border_Area" in area.name:
		queue_free()
