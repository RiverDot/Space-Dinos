extends CharacterBody2D

var horizontal_speed = 20
var slow_rate = 5.0
@export var max_velocity: Vector2 = Vector2(500.0, 0)
@export var horizontal_bounds: Vector2 = Vector2(0, 0)

@export var paraDino: PackedScene

var vertical_velocity: float = 0
var gravity = 15
var air_resistence = 0.99
var terminal_fall_velocity = 100
var floor_height = 0

var ship_destroyed = false

var fuelParts: Array[PartFuel] = []
var thrusterParts: Array[PartThruster] = []

var infFuelCheat = false
var invincibleCheat = false

var boosting = false

var flight_scene

var tween: Tween
	
func _ready():
	flight_scene = get_tree().get_first_node_in_group("FlightScreen")

func _physics_process(delta):

	if (_is_fuel_empty() || !_thrusters_exist()) && vertical_velocity <= 0:
		_destroy_ship(true)
		return

	if ship_destroyed:
		vertical_velocity = 0
		return

	var moveLR = Input.get_axis("Player Left", "Player Right")
	var moveUD = Input.get_axis("Player Up", "Player Down")
	var move = Vector2(moveLR , 0)

	for part in thrusterParts:
		part._set_particles_(false)

	if boosting:
		_boost_thrust(delta)
	elif moveUD < 0:
		_try_thrust(delta)
	
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

	if floor_height > flight_scene.height_goal / flight_scene.map_size_multiplier:
		_destroy_ship(false)
		flight_scene._on_game_won()

func _boost_thrust(delta):
	if thrusterParts.size() == 0:
		return
	var total_thrust_force = 0
	for part in thrusterParts:
		var fuel_used = part.fuel_consumption * 2 * delta
		if fuel_used > 0:
			total_thrust_force += part.thrust_power * fuel_used * 2 / (part.fuel_consumption * 2 * delta)
			part._set_particles_(true, true)
	
	if total_thrust_force > 0:
		total_thrust_force += gravity # to at least overpower gravity
		vertical_velocity += total_thrust_force * delta
	get_tree().get_first_node_in_group("ShipStatus")._update_fuel(fuelParts)

func _try_thrust(delta):
	if thrusterParts.size() == 0:
		return
	var total_thrust_force = 0
	for part in thrusterParts:
		var fuel_used = _try_consume_fuel(part.fuel_consumption * delta)
		if fuel_used > 0:
			total_thrust_force += part.thrust_power * fuel_used / (part.fuel_consumption * delta)
			part._set_particles_(true)
	
	if total_thrust_force > 0:
		total_thrust_force += gravity # to at least overpower gravity
		vertical_velocity += total_thrust_force * delta
	get_tree().get_first_node_in_group("ShipStatus")._update_fuel(fuelParts)

func _try_consume_fuel(rate: float) -> float:
	if infFuelCheat:
		return rate
	if fuelParts.size() == 0:
		return 0
	var fuel_conspumtion_rate = rate
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
	return fuel_used
		

func _is_fuel_empty() -> bool:
	if fuelParts.size() == 0:
		return true
	for part in fuelParts:
		if part._get_fuel_percent() > 0:
			return false
	return true

func _thrusters_exist() -> bool:
	if thrusterParts.size() == 0:
		return false
	else:
		return true

func _destroy_part(part):
	if invincibleCheat:
		return
	if (part.id == 1):
		_destroy_ship(true)
	else:
		$Ship._destroy_part(part)

func _destroy_ship(lose: bool):
	if ship_destroyed:
		return
	ship_destroyed = true
	vertical_velocity = 0
	if lose:
		get_parent()._on_game_over()
		_spawn_paradino()
	$Ship._destroy_ship()
	

func _spawn_paradino():
	var para = paraDino.instantiate()
	add_child(para)
	para.global_position = $Ship._get_part(1).global_position

func _update_ship():
	fuelParts.clear()
	for part in get_tree().get_nodes_in_group("FuelPart"):
		if is_ancestor_of(part):
			fuelParts.append(part)
	get_tree().get_first_node_in_group("ShipStatus")._update_fuel(fuelParts)
	thrusterParts.clear()
	for part in get_tree().get_nodes_in_group("ThrusterPart"):
		if is_ancestor_of(part):
			thrusterParts.append(part)
	get_tree().get_first_node_in_group("ShipStatus")._update_thrusters(thrusterParts)

func _boost():
	boosting = true
	tween = get_tree().create_tween()
	tween.tween_interval(1)
	tween.tween_callback(_end_boost)

func _end_boost():
	boosting = false

func _exit_tree():
	if tween == null:
		return
	if tween.is_running():
		tween.stop()
		tween = null

