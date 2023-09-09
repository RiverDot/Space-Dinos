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
		current_ship.grid = _get_ship_data()
		current_ship._load()

func _save_ship():
	print("saving ship")
	current_ship_data = ShipData.new()

	current_ship_data.grid = []
	for i in range(0, 9):
		current_ship_data.grid.append([])
		for j in range(0, 9):
			current_ship_data.grid[i].append(current_ship.grid[i][j])

func _get_ship_data() -> Array[Array]:
	var data_grid: Array[Array] = []
	for i in range(0, 9):
		data_grid.append([])
		for j in range(0, 9):
			data_grid[i].append(current_ship_data.grid[i][j])
	return data_grid
