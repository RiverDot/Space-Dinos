extends Node2D

var rng = RandomNumberGenerator.new()
@export
var obstacle_cooldown = 0.5 
var current_obstacle_cooldown = 0
@export
var money_cooldown = 25
var current_money_cooldown = 0
@export
var booster_cooldown = 17 
var current_booster_cooldown = 0
const FLYING_DINO = preload("res://Nodes/Game/Obstacle/flying_dino.tscn")
const PLANE = preload("res://Nodes/Game/Obstacle/plane.tscn")
const BALLOON = preload("res://Nodes/Game/Obstacle/balloon.tscn")
const METEOR = preload("res://Nodes/Game/Obstacle/meteor.tscn")
const SATELLITE = preload("res://Nodes/Game/Obstacle/satellite.tscn")
const OBSTACLE = preload("res://Nodes/Game/Obstacle/obstacle.tscn")
const MONEY = preload("res://Nodes/Game/pick_ups/money.tscn")
const BOOSTER = preload("res://Nodes/Game/pick_ups/boost.tscn")
var Zones = {"Troposphere": 20, "Stratosphere": 50, "Mesosphere": 10000}
var background

# Called when the node enters the scene tree for the first time.
func _ready():
	background = get_node("../Background")
	
func _get_current_zone():
	var flightScene = get_parent()
	var height = flightScene.height 
	#print("Height:"+ str(height/1000))
	for key in Zones:
		#print("index: %s, value: %d" % [key, Zones[key]])
		if Zones[key] > (height/1000):
			return key
	
func _spawn_at_spawner_point_withoutNumber(obstacle):
	if obstacle.spawnPoint == "TOP":
		var random_number = rng.randf_range(-225, 225)
		obstacle.transform = Transform2D(0, Vector2(random_number, (background.position.y*-1)-20))
		background.add_child(obstacle)
		#print(random_number)
	elif obstacle.spawnPoint == "LEFT":
		var random_number = rng.randf_range(-1000, 120)
		obstacle.transform = Transform2D(0, Vector2(-525, (background.position.y*-1)-random_number))
		background.add_child(obstacle)
		#print(random_number)
	elif obstacle.spawnPoint == "RIGHT":
		var random_number = rng.randf_range(-1000, 120)
		obstacle.transform = Transform2D(0, Vector2(525, (background.position.y*-1)-random_number))
		background.add_child(obstacle)
	
func _spawn_troposphere_obstacle():
	var obstacleNumber = rng.randi_range(1,10)
	if obstacleNumber <= 2:
		var obstacle = METEOR.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)
	if obstacleNumber >= 3 && obstacleNumber < 7:
		var obstacle = FLYING_DINO.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)
	elif obstacleNumber >= 7:
		var obstacle = PLANE.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)
		

func _spawn_stratosphere_obstacle():
	var obstacleNumber = rng.randi_range(1,10)
	var spawnerNumber = rng.randi_range(1,3)
	if obstacleNumber <= 3:
		var obstacle = METEOR.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)
	if obstacleNumber >3 && obstacleNumber < 7:
		var obstacle = PLANE.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)
	elif obstacleNumber >= 7:
		var obstacle = BALLOON.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)

func _spawn_mesosphere_obstacle():
	var obstacleNumber = rng.randi_range(1,10)
	if obstacleNumber <= 5:
		var obstacle = SATELLITE.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)
	elif obstacleNumber > 5:
		var obstacle = METEOR.instantiate()
		obstacle._set_random_spawn_point()
		obstacle._set_random_movement()
		_spawn_at_spawner_point_withoutNumber(obstacle)

func _spawn_obstacle():
	var current_zone = _get_current_zone()
	if current_zone == "Mesosphere":
		_spawn_mesosphere_obstacle()
	elif current_zone == "Stratosphere":
		_spawn_stratosphere_obstacle()
	elif current_zone == "Troposphere":
		_spawn_troposphere_obstacle()
	
	current_obstacle_cooldown = obstacle_cooldown
	

func _spawn_money():
	var random_number = rng.randf_range(-225, 225)
	var money = MONEY.instantiate()
	money.transform = Transform2D(0, Vector2(random_number, (background.position.y*-1)-20))
	background.add_child(money)
	#print(random_number)
	current_money_cooldown = money_cooldown

func _spawn_booster():
	var random_number = rng.randf_range(-225, 225)
	var booster = BOOSTER.instantiate()
	booster.transform = Transform2D(0, Vector2(random_number, (background.position.y*-1)-20))
	background.add_child(booster)
	current_booster_cooldown = booster_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_obstacle_cooldown = current_obstacle_cooldown - delta
	current_money_cooldown = current_money_cooldown - delta
	current_booster_cooldown = current_booster_cooldown - delta
	
	#print("Background")
	#print(background.position.y)
	if current_obstacle_cooldown < 0:
		_spawn_obstacle()
	if current_money_cooldown < 0:
		_spawn_money()
	if current_booster_cooldown < 0:
		_spawn_booster()
