extends Obstacle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	translate(movementVector)
	
func _set_random_spawn_point():
	var randomPosition = rng.randi_range(1,3)
	if randomPosition == 1:
		spawnPoint = "LEFT"
	elif randomPosition == 2:
		spawnPoint = "RIGHT"
	elif randomPosition == 3:
		spawnPoint = "TOP"
	
func _set_random_movement():
	minXSpeed = 1
	maxXSpeed = 5
	minYSpeed = -5
	maxYSpeed = 5
	movementVector = Vector2(rng.randf_range(minXSpeed, maxXSpeed), rng.randf_range(minYSpeed, maxYSpeed))
	if spawnPoint == "RIGHT":
		movementVector.x = movementVector.x*-1
		
	
