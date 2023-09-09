extends CharacterBody2D

var horizontal_speed = 20
var slow_rate = 5.0
@export var max_velocity: Vector2 = Vector2(500.0, 0)
@export var horizontal_bounds: Vector2 = Vector2(0, 0)

var thrust_force = 20
var vertical_velocity: float = 0
var gravity = 15
var max_vertical_velocity = 20
var air_resistence = 0.99
var terminal_fall_velocity = 100
var floor_height = 0
	
func _physics_process(delta):
	var moveLR = Input.get_axis("Player Left", "Player Right")
	var moveUD = Input.get_axis("Player Up", "Player Down")
	var move = Vector2(moveLR , 0)

	if moveUD < 0:
		vertical_velocity += thrust_force * delta
	
	vertical_velocity -= gravity * delta

	vertical_velocity *= air_resistence
	
	if move == Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, delta * slow_rate)
	else:
		velocity += move * horizontal_speed

	velocity = velocity.clamp(-max_velocity, max_velocity)
	move_and_slide()

	if position.x < horizontal_bounds.x:
		position.x = horizontal_bounds.x
		velocity.x = 0
	elif position.x > horizontal_bounds.y:
		position.x = horizontal_bounds.y
		velocity.x = 0

	floor_height += vertical_velocity

	if floor_height < 0:
		floor_height = 0
		vertical_velocity = 0

func _destroy_part(part):
	if (part.id == 1):
		$Ship._destroy_ship()
		get_parent()._on_game_over()
	else:
		$Ship._destroy_part(part)
