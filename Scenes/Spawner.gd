extends Node2D

var rng = RandomNumberGenerator.new()
@export
var obstacle_cooldown = 2 
var current_obstacle_cooldown = 0
var money_cooldown = 2
var current_money_cooldown = 0
var booster_cooldown = 2 
var current_booster_cooldown = 0
const OBSTACLE = preload("res://Nodes/Game/obstacle.tscn")
const MONEY = preload("res://Nodes/Game/pick_ups/money.tscn")
const BOOSTER = preload("res://Nodes/Game/pick_ups/boost.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_obstacle_cooldown = current_obstacle_cooldown - delta
	current_money_cooldown = current_money_cooldown - delta
	current_booster_cooldown = current_booster_cooldown - delta
	if current_obstacle_cooldown < 0:
		var random_number = rng.randf_range(500, 1500)
		var obstacle = OBSTACLE.instantiate()
		obstacle.transform = Transform2D(0, Vector2(random_number, 10))
		obstacle.movementVector = Vector2(1, 1)
		add_child(obstacle)
		print(random_number)
		current_obstacle_cooldown = obstacle_cooldown
	if current_money_cooldown < 0:
		var random_number = rng.randf_range(500, 1500)
		var money = MONEY.instantiate()
		money.transform = Transform2D(0, Vector2(random_number, 10))
		add_child(money)
		print(random_number)
		current_money_cooldown = money_cooldown
	if current_booster_cooldown < 0:
		var random_number = rng.randf_range(500, 1500)
		var booster = BOOSTER.instantiate()
		booster.transform = Transform2D(0, Vector2(random_number, 10))
		add_child(booster)
		current_booster_cooldown = booster_cooldown
