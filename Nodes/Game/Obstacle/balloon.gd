extends Obstacle

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	translate(movementVector)
	
func _set_random_spawn_point():
	spawnPoint = "TOP"
	
func _set_random_movement():
	minXSpeed = 1
	maxXSpeed = 4
	minYSpeed = -1
	maxYSpeed = -3
	movementVector = Vector2(rng.randf_range(minXSpeed, maxXSpeed), rng.randf_range(minYSpeed, maxYSpeed))
	
