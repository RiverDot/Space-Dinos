extends Node2D

@export var vert_speed: float = 0.0
@export var vert_speed_multiplier: float = 5.0
@export var drag_mod: float = 0
@export var scroll_amount: float

var height: float = 0
var max_height: float = 0
var game_over = false
var game_won = false
var map_size_multiplier: float = 4
var height_goal = 360000 # moon distance at perigee

signal gameover(score: float)

@onready var rocket_ship = $"Rocket Ship"
@onready var speed_label = $Score/SpeedLabel
@onready var bg_sprite: Node2D = $Background
var format_string = "Vertical Velocity: {vert}m/s \nHeight: {height}km \nMax Height:{max_height}km"

func _physics_process(_delta):
	scroll_amount = rocket_ship.vertical_velocity
	height = bg_sprite.position.y
	speed_label.text = format_string.format({"vert": snapped(scroll_amount * map_size_multiplier, 0.1), "height": snapped(height/(1000.0/map_size_multiplier),0.1), "max_height": snapped(max_height/(1000.0/map_size_multiplier),0.1)})

	if max_height < height:
		max_height = height

func _on_game_over():
	if not game_over:
		game_over = true
		scroll_amount = 0
		emit_signal("gameover", height/1000)

func _on_game_won():
	if not game_won:
		scroll_amount = 0
		game_won = true
		get_tree().get_first_node_in_group("GameWon")._on_game_won()

func _get_percent_to_goal():
	return height/(height_goal/map_size_multiplier)
