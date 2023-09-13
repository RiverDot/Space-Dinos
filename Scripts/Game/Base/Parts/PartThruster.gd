extends PartBase

class_name PartThruster

var ui_id: int

var thrust_power: float

var fuel_consumption: float

func _setup(part: Part):
	super(part)
	thrust_power = $ThrusterComponent.thrust_power
	fuel_consumption = $ThrusterComponent.fuel_consumption

func _break_part(part_pos):
	_set_particles_(false)
	super(part_pos)

func _set_particles_(on: bool):
	if on:
		$Sprite/FireParticles.visible = true
		$Sprite/CloudParticles.emitting = true
	else:
		$Sprite/FireParticles.visible = false
		$Sprite/CloudParticles.emitting = false
