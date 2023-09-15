extends CanvasLayer

@export var fuel_bar: PackedScene

@export var thruster_status: PackedScene

var fuel_bars: Array

var thruster_statuses: Array

var fuel_setup = false

var thruster_setup = false

func _setup_fuel(parts: Array):
	fuel_bars = []
	for part in parts:
		part.ui_id = fuel_bars.size()
		var fuel_bar_instance = fuel_bar.instantiate()
		$Control/FuelScroll/FuelContainer.add_child(fuel_bar_instance)
		fuel_bars.append(fuel_bar_instance)
	fuel_setup = true

func _update_fuel(parts: Array):
	if not fuel_setup:
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

func _setup_thrusters(parts: Array):
	thruster_statuses = []
	for part in parts:
		part.ui_id = thruster_statuses.size()
		var thruster_status_instance = thruster_status.instantiate()
		$Control/ThrusterScroll/ThrusterContainer.add_child(thruster_status_instance)
		thruster_statuses.append(thruster_status_instance)
	thruster_setup = true

func _update_thrusters(parts: Array):
	if not thruster_setup:
		_setup_thrusters(parts)
	var i: int = 0
	for status in thruster_statuses:
		var found = false
		for part in parts:
			if part.ui_id == i:
				status.modulate = Color.WHITE
				found = true
				break
		if not found:
			status.modulate = Color.RED
		i += 1
