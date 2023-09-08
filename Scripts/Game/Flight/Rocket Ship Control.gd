extends CharacterBody2D

@export var speed = 10
@export var slow_rate = 5.0
@export var max_velocity: Vector2 = Vector2(300.0, 200.0)
@export var launch_force: float = 20
@export var horizontal_bounds: Vector2 = Vector2(0, 0)
	
func _physics_process(delta):
	var moveLR = Input.get_axis("Player Left", "Player Right")
	var moveUD = Input.get_axis("Player Up", "Player Down")
	var move = Vector2(moveLR , moveUD)
	
	if move == Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, delta * slow_rate)
	else:
		velocity += move * speed

	velocity = velocity.clamp(-max_velocity, max_velocity)
	move_and_slide()

	if position.x < horizontal_bounds.x:
		position.x = horizontal_bounds.x
		velocity.x = 0
	elif position.x > horizontal_bounds.y:
		position.x = horizontal_bounds.y
		velocity.x = 0
