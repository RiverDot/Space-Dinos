extends Node2D

@export var vert_speed: float = 0.0
@export var vert_speed_multiplier: float = 5.0
@export var scroll_amount: float
var launched: bool = false

@export var path_to_rocket_ship: NodePath
@onready var rocket_ship = $"Rocket Ship"

func _process(_delta):
	if launched :
		scroll_amount = vert_speed * vert_speed_multiplier
	elif Input.is_action_pressed("Launch"):
		vert_speed = rocket_ship.launch_force
		launched = true
