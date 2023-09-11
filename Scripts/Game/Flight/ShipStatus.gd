extends CanvasLayer

@export var fuel_bar: PackedScene

var fuel_bars: Array

var setup = false

func _setup_fuel(parts: Array):
	fuel_bars = []
	for part in parts:
		part.ui_id = fuel_bars.size()
		var fuel_bar_instance = fuel_bar.instantiate()
		$Scroll/FuelContainer.add_child(fuel_bar_instance)
		fuel_bars.append(fuel_bar_instance)
	setup = true
		

func _update_fuel(parts: Array):
	if not setup:
		_setup_fuel(parts)
	var i: int = 0
	for bar in fuel_bars:
		var found = false
		for part in parts:
			if part.ui_id == i:
				bar.value = part._get_fuel_percent()
				found = true
				break
		if not found:
			bar.value = 0
		i += 1
