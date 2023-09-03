extends Node2D

@export var vert_speed: float = 0.0
@export var vert_speed_multiplier: float = 5.0
@export var drag_mod: float = 0
@export var scroll_amount: float
var launched: bool = false
var height: float = 0

@onready var rocket_ship = $"Rocket Ship"
@onready var speed_label = $SpeedLabel
@onready var bg_sprite: Node2D = self.get_child(0)
var format_string = "Vertical Speed: {vert} \nHeight: {height}"

func _process(_delta):
	if launched :
		scroll_amount = vert_speed * vert_speed_multiplier
		vert_speed -= drag_mod
		height = bg_sprite.position.y
		speed_label.text = format_string.format({"vert": vert_speed, "height": height})
	elif Input.is_action_pressed("Launch"):
		vert_speed = rocket_ship.launch_force
		launched = true
