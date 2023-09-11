extends PartBase

class_name PartThruster

var ui_id: int

var thrust_power: float

var fuel_consumption: float

func _setup(part: Part):
	super(part)
	thrust_power = $ThrusterComponent.thrust_power
	fuel_consumption = $ThrusterComponent.fuel_consumption