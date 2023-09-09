extends Node2D

var parts: Array[PartBase]

var grid: Array[Array]

var part_data: Array

func _load():
	parts = []
	if not grid:
		grid = []
		for i in range(0, 9):
			grid.append([])
			for j in range(0, 9):
				grid[i].append(-1)
	_load_parts()

func _load_parts():
	part_data = _dir_contents("res://Resources/Data/Parts/")

	var i = 0
	var j = 0
	for row in grid:
		for cell in row:
			if cell != -1:
				_load_part(Vector2(i, j), cell)
			j+=1
		i+=1
		j=0

	if get_tree().get_first_node_in_group("GameScene").current_scene == 1: # equal to FLIGHT
		var cockpit_pos: Vector2 = _get_part(1).grid_pos
		position = -Vector2(cockpit_pos.x * 24, cockpit_pos.y * 24) + Vector2(12 * 8, 12 * 8)

func _load_part(grid_pos: Vector2, part_id: int):
	for part in part_data:
		if part.id == part_id:
			var new_part = part.node.instantiate()

			new_part._setup(part)
			new_part.grid_pos = grid_pos

			if get_tree().get_first_node_in_group("GameScene").current_scene == 0: # equal to BASE
				new_part.position = get_tree().get_first_node_in_group("ShipBuilder")._get_grid_pos(grid_pos)
			else:
				new_part.position = Vector2(grid_pos.x * 24, grid_pos.y * 24) - Vector2(12 * 8, 12 * 8)
				new_part._get_sprite().scale = Vector2(0.19, 0.19)
			add_child(new_part)
			parts.append(new_part)
			break

func _dir_contents(path) -> Array:
	var files: Array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				files.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files

func _get_part(part_id: int) -> PartBase:
	for part in parts:
		if part.id == part_id:
			return part
	return null

func _remove_from_grid(part: PartBase):
	grid[part.grid_pos.x][part.grid_pos.y] = -1

func _destroy_part(part):
	parts.erase(part)
	_remove_from_grid(part)
	part.queue_free()

	var web = _get_connection_web(_get_part(1))
	var destroy_list: Array = []

	for check_part in parts:
		if check_part not in web:
			destroy_list.append(check_part)

	while !destroy_list.is_empty():
		_destroy_part_no_check(destroy_list[0])
		destroy_list.erase(destroy_list[0])

func _destroy_part_no_check(part):
	parts.erase(part)
	_remove_from_grid(part)
	part.queue_free()

func _destroy_ship():
	while !parts.is_empty():
		_destroy_part_no_check(parts[0])

func _get_connection_web(main_part) -> Array:
	var parts_to_check = []
	var connected_parts = []

	parts_to_check.append(main_part)
	connected_parts.append(main_part)

	while parts_to_check.size() > 0:
		var part = parts_to_check.pop_back()
		if part.grid_pos.x > 0:
			if grid[part.grid_pos.x - 1][part.grid_pos.y] != -1:
				var part_to_check = _get_part_at_grid_pos(Vector2(part.grid_pos.x - 1, part.grid_pos.y))
				if part_to_check not in connected_parts:
					parts_to_check.append(part_to_check)
					connected_parts.append(part_to_check)
		if part.grid_pos.x < 8:
			if grid[part.grid_pos.x + 1][part.grid_pos.y] != -1:
				var part_to_check = _get_part_at_grid_pos(Vector2(part.grid_pos.x + 1, part.grid_pos.y))
				if part_to_check not in connected_parts:
					parts_to_check.append(part_to_check)
					connected_parts.append(part_to_check)
		if part.grid_pos.y > 0:
			if grid[part.grid_pos.x][part.grid_pos.y - 1] != -1:
				var part_to_check = _get_part_at_grid_pos(Vector2(part.grid_pos.x, part.grid_pos.y - 1))
				if part_to_check not in connected_parts:
					parts_to_check.append(part_to_check)
					connected_parts.append(part_to_check)
		if part.grid_pos.y < 8:
			if grid[part.grid_pos.x][part.grid_pos.y + 1] != -1:
				var part_to_check = _get_part_at_grid_pos(Vector2(part.grid_pos.x, part.grid_pos.y + 1))
				if part_to_check not in connected_parts:
					parts_to_check.append(part_to_check)
					connected_parts.append(part_to_check)

	return connected_parts

func _get_part_at_grid_pos(grid_pos: Vector2) -> PartBase:
	for part in parts:
		if part.grid_pos == grid_pos:
			return part
	return null
