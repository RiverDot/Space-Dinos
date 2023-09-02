extends CharacterBody2D

@export var speed = 10
@export var slow_rate = 5.0
@export var max_velocity: Vector2 = Vector2(300.0, 300.0)
	
func _physics_process(delta):
	var move = Input.get_axis("Player Left", "Player Right")
	
	if move == 0:
		velocity = velocity.lerp(Vector2.ZERO, delta * slow_rate)
	else:
		velocity.x += move * speed

	velocity = velocity.clamp(-max_velocity, max_velocity)
	move_and_slide()
