extends PartBase

class_name PartThruster

var ui_id: int

var thrust_power: float

var fuel_consumption: float

var thruster_tween: Tween

func _setup(part: Part):
	super(part)
	thrust_power = $ThrusterComponent.thrust_power
	fuel_consumption = $ThrusterComponent.fuel_consumption

func _break_part(part_pos):
	_set_particles_(false)
	super(part_pos)
	if thruster_tween:
		if thruster_tween.is_running():
			thruster_tween.stop()
			thruster_tween = null

func _set_particles_(on: bool, boost: bool = false):
	if on:
		$Sprite/FireParticles.visible = true
		$Sprite/CloudParticles.emitting = true
		if is_broken:
			_set_volume(-80)
		else:
			_set_thrust_volume(true)
		if boost:
			$Sprite/FireParticles.modulate = Color(0.5, 0, 1, 1)
		else:
			$Sprite/FireParticles.modulate = Color(1, 1, 1, 1)
	else:
		$Sprite/FireParticles.visible = false
		$Sprite/CloudParticles.emitting = false
		if is_broken:
			_set_volume(-80)
		else:
			_set_thrust_volume(false)

func _set_thrust_volume(_on: bool):
	if !is_inside_tree():
		return

	if _on:
		thruster_tween = get_tree().create_tween()
		thruster_tween.tween_method(_set_volume, $ThrusterSound.volume_db, -10, 0.05)
	else:
		thruster_tween = get_tree().create_tween()
		thruster_tween.tween_method(_set_volume, $ThrusterSound.volume_db, -80, 0.05)

func _set_volume(_vol: float):
	$ThrusterSound.volume_db = _vol

func _exit_tree():
	super()
	if thruster_tween:
		if thruster_tween.is_running():
			thruster_tween.stop()
			thruster_tween = null
