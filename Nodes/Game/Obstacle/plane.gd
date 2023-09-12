extends Obstacle

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
	minXSpeed = 3
	maxXSpeed = 10
	minYSpeed = -3
	maxYSpeed = 3
	movementVector = Vector2(rng.randf_range(minXSpeed, maxXSpeed), rng.randf_range(minYSpeed, maxYSpeed))
	if spawnPoint == "RIGHT":
		movementVector.x = movementVector.x*-1
		$Sprite2D.scale.x = $Sprite2D.scale.x*-1
		
