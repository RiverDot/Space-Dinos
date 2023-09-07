extends Node2D

@export var ship_node: PackedScene

var current_ship = null

var current_ship_data: ShipData = null

func _load_ship(target):
	if current_ship_data == null:
		print("creating new ship")
		current_ship = ship_node.instantiate()
		target.add_child(current_ship)
		if target.is_in_group("ShipBuilder"):
			target.ship = current_ship
		current_ship._load()
	else:
		print("loading ship")
		current_ship = ship_node.instantiate()
		target.add_child(current_ship)
		if target.is_in_group("ShipBuilder"):
			target.ship = current_ship
		current_ship.grid = current_ship_data.grid
		current_ship._load()

func _save_ship():
	print("saving ship")
	current_ship_data = ShipData.new()
	current_ship_data.grid = current_ship.grid
