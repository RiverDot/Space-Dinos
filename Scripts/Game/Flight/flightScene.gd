extends Node2D

@export var vert_speed: float = 0.0
@export var vert_speed_multiplier: float = 5.0
@export var drag_mod: float = 0
@export var scroll_amount: float
var launched: bool = false
var height: float = 0
var max_height: float = 0

signal gameover(score: float)

@onready var rocket_ship = $"Rocket Ship"
@onready var speed_label = $Score/SpeedLabel
@onready var bg_sprite: Node2D = $Background
var format_string = "Vertical Speed: {vert} \nHeight: {height} \nMax Height:{max_height}"

func _process(_delta):
	if launched :
		scroll_amount = vert_speed * vert_speed_multiplier
		vert_speed -= drag_mod
		height = bg_sprite.position.y
		speed_label.text = format_string.format({"vert": snapped(vert_speed,0.1), "height": snapped(height,0.1), "max_height": snapped(max_height,0.1)})
		if max_height < height:
			max_height = height
		if height <= 0:
			gameover.emit(snapped(max_height,0.1))
	elif Input.is_action_pressed("Launch"):
		vert_speed = rocket_ship.launch_force
		launched = true
