extends PartBase

class_name PartFuel

var ui_id: int

var max_fuel: float

var fuel: float

func _setup(part: Part):
	super(part)
	max_fuel = $FuelComponent.max_fuel
	fuel = max_fuel

func _get_fuel_percent() -> float:
	return fuel / max_fuel

func _use_fuel(amount: float) -> float: # takes how much is tried to use and returns amount used
	fuel -= amount
	var mod = _get_fuel_percent()
	$Sprite/Fuel.modulate = Color(mod, mod, mod, 1)
	if fuel < 0:
		var amount_used = -fuel
		fuel = 0
		return amount_used
	return amount
