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

var ship_destroyed = false

var fuelParts: Array[PartFuel] = []
	
func _physics_process(delta):

	if _is_fuel_empty() && vertical_velocity <= 0:
		ship_destroyed = true
		$Ship._destroy_ship()
		get_parent()._on_game_over()
		return

	if ship_destroyed:
		vertical_velocity = 0
		return

	var moveLR = Input.get_axis("Player Left", "Player Right")
	var moveUD = Input.get_axis("Player Up", "Player Down")
	var move = Vector2(moveLR , 0)

	if moveUD < 0:
		if fuelParts.size() != 0:
			var fuel_conspumtion_rate = 50.0 * delta
			var fuel_to_consume = fuel_conspumtion_rate
			var fuel_used = 0
			var all_empty = false
			while fuel_to_consume > 0 and !all_empty:
				all_empty = true
				var useable_fuel_parts = []
				for part in fuelParts:
					if part._get_fuel_percent() > 0:
						useable_fuel_parts.append(part)
				var current_rate = fuel_to_consume / useable_fuel_parts.size()
				for part in useable_fuel_parts:
					var used_here = part._use_fuel(current_rate)
					fuel_used += used_here
					fuel_to_consume -= used_here
			if fuel_used > 0:
				vertical_velocity += thrust_force * delta * fuel_used/fuel_conspumtion_rate
				get_tree().get_first_node_in_group("ShipStatus")._update_fuel(fuelParts)
	
	vertical_velocity -= gravity * delta

	vertical_velocity *= air_resistence
	
	if move == Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, delta * slow_rate)
	else:
		velocity += move * horizontal_speed

	$Ship.rotation = velocity.x * 0.0005

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

func _is_fuel_empty() -> bool:
	if fuelParts.size() == 0:
		return true
	for part in fuelParts:
		if part._get_fuel_percent() > 0:
			return false
	return true

func _destroy_part(part):
	if (part.id == 1):
		ship_destroyed = true
		$Ship._destroy_ship()
		get_parent()._on_game_over()
	else:
		$Ship._destroy_part(part)

func _update_ship():
	fuelParts.clear()
	for part in get_tree().get_nodes_in_group("FuelPart"):
		if is_ancestor_of(part):
			fuelParts.append(part)
	get_tree().get_first_node_in_group("ShipStatus")._update_fuel(fuelParts)
