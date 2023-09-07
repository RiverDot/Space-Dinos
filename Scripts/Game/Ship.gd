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
