extends Obstacle

# Called when the node enters the scene tree for the first time.
func _ready():
	minXSpeed = 5
	maxXSpeed = 10
	minYSpeed = 1
	maxYSpeed = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	translate(movementVector)
	
func _set_random_spawn_point():
	var randomPosition = rng.randi_range(1,2)
	if randomPosition == 1:
		spawnPoint = "LEFT"
	elif randomPosition == 2:
		spawnPoint = "RIGHT"
	
func _set_random_movement():
	movementVector = Vector2(rng.randf_range(minXSpeed, maxXSpeed), rng.randf_range(minYSpeed, maxYSpeed))
	if spawnPoint == "RIGHT":
		movementVector.x = movementVector.x*-1
	if spawnPoint == "LEFT":
		$Sprite2D.scale.x = $Sprite2D.scale.x*-1
		
	
