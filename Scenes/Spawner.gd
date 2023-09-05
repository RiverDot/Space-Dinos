extends Node2D

var rng = RandomNumberGenerator.new()
const OBSTACLE = preload("res://Nodes/Game/obstacle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var random_number = rng.randf_range(20.0, 50.0)
	var obstacle = OBSTACLE.instantiate()
	obstacle.transform = Transform2D(0, Vector2(random_number, 10))
	print(random_number)
