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

var money_earned: float = 0

var game_manager

signal gameover(score: float)

@onready var rocket_ship = $"Rocket Ship"
@onready var speed_label = $Score/SpeedLabel
@onready var bg_sprite: Node2D = $Background
var format_string = "Vertical Velocity: {vert}m/s \nAltitude: {height}km \nRecord Altitude:{max_height}km"

func _ready():
	game_manager = get_tree().get_first_node_in_group("GameManager")
	max_height = game_manager.record_height

func _physics_process(_delta):
	if game_over or game_won:
		return

	scroll_amount = rocket_ship.vertical_velocity
	height = bg_sprite.position.y
	speed_label.text = format_string.format({"vert": snapped(scroll_amount * map_size_multiplier, 0.1), "height": snapped(height/(1000.0/map_size_multiplier),0.01), "max_height": snapped(max_height/(1000.0/map_size_multiplier),0.01)})

	if max_height < height:
		max_height = height

func _on_game_over():
	if not game_over:
		game_over = true
		_common_game_end()
		game_manager.total_loses += 1
		emit_signal("gameover", height/(1000.0/map_size_multiplier))

func _on_game_won():
	if not game_won:
		game_won = true
		_common_game_end()
		get_tree().get_first_node_in_group("GameWon")._on_game_won()

func _common_game_end():
	scroll_amount = 0
	money_earned += roundi(height/(1000.0/map_size_multiplier))
	get_tree().get_first_node_in_group("MoneyManager")._change_money(money_earned)
	game_manager.total_money_earned += money_earned
	game_manager.total_distance_travelled += height/(1000.0/map_size_multiplier)
	game_manager.record_height = max_height

func _get_percent_to_goal():
	return height/(height_goal/map_size_multiplier)
