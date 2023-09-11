extends Node2D

var selected_part_res = null
var selected_part = null
var moving = false

var selected_grid: Vector2

var buildLimitsStart = Vector2(960, 336)
var buildLimitsEnd = Vector2(1392, 768)
var cellS = 48

var ship

func _on_part_selected(part: Part):
	if selected_part:
		selected_part.queue_free()

	selected_part_res = part

	var newPart = part.node.instantiate()
	newPart._setup(part)
	add_child(newPart)
	selected_part = newPart

func _process(_delta):
	if selected_part:
		$BuildLight.visible = true
		$BuildLight.position = get_viewport().get_mouse_position()
		selected_part.position = get_viewport().get_mouse_position()

		selected_part.modulate = Color(0.9, 0.3, 0.3, 0.7)

		selected_part.z_index = 3

		if _in_zone():
			if _check_grid_space():
				selected_part.modulate = Color(1, 1, 1, 0.7)
				if moving:
					if Input.is_action_just_released("PointerAction"):
						_place_part_at_grid_pos(selected_part, selected_grid)
						moving = false
						selected_part.modulate = Color(1, 1, 1, 1)
						selected_part.z_index = 0
						selected_part = null
				else:
					if Input.is_action_just_pressed("PointerAction"):
						_add_part(selected_part)
						_place_part_at_grid_pos(selected_part, selected_grid)
						
						get_tree().get_first_node_in_group("MoneyManager")._try_spend_money(selected_part.value)
						get_tree().get_first_node_in_group("PartSelector")._update_buttons()

						selected_part = null

						if Input.is_action_pressed("Shift"):
							if selected_part_res.cost <= get_tree().get_first_node_in_group("MoneyManager").money && !_check_limit(selected_part_res.id, selected_part_res.limit):
								_on_part_selected(selected_part_res)

		if Input.is_action_just_released("PointerAction") && moving:
			_place_part_at_grid_pos(selected_part, selected_part.grid_pos)
			selected_part.position = _get_grid_pos(selected_part.grid_pos)
			moving = false
			selected_part = null
		elif Input.is_action_just_pressed("PointerActionAlt"):
			selected_part.queue_free()
			selected_part = null
	else:
		$BuildLight.visible = false
		if Input.is_action_just_pressed("PointerAction"):
			var focused_part = _try_raycast_part()
			if focused_part != null:
				moving = true
				selected_part = focused_part
				_remove_part_at_grid_pos(selected_part, selected_part.grid_pos)
		if Input.is_action_just_pressed("PointerActionAlt"):
			var focused_part = _try_raycast_part()
			if focused_part != null:
				_remove_part_at_grid_pos(focused_part, focused_part.grid_pos)
				ship.parts.erase(focused_part)
				get_tree().get_first_node_in_group("MoneyManager")._change_money(focused_part.value)
				focused_part.queue_free()
				get_tree().get_first_node_in_group("PartSelector")._update_buttons()

func _place_part_at_grid_pos(part, grid_pos):
	ship.grid[grid_pos.x][grid_pos.y] = part.id
	part.grid_pos = grid_pos

	if part.size.x > 1:
		for i in range(grid_pos.x + 1, grid_pos.x + part.size.x):
			ship.grid[i][grid_pos.y] = 100
	
	if part.size.y > 1:
		for i in range(grid_pos.y + 1, grid_pos.y + part.size.y):
			ship.grid[grid_pos.x][i] = 101
			if part.size.x > 1:
				for j in range(grid_pos.x + 1, grid_pos.x + part.size.x):
					ship.grid[j][i] = 101

	part.modulate = Color(1, 1, 1, 1)
	part.z_index = 0

func _remove_part_at_grid_pos(part, grid_pos):
	ship.grid[grid_pos.x][grid_pos.y] = -1

	if part.size.x > 1:
		for i in range(grid_pos.x + 1, grid_pos.x + part.size.x):
			ship.grid[i][grid_pos.y] = -1

	if part.size.y > 1:
		for i in range(grid_pos.y + 1, grid_pos.y + part.size.y):
			ship.grid[grid_pos.x][i] = -1
			if part.size.x > 1:
				for j in range(grid_pos.x + 1, grid_pos.x + part.size.x):
					ship.grid[j][i] = -1

func _get_grid_pos(grid_pos: Vector2) -> Vector2:
	return Vector2(buildLimitsStart.x + (grid_pos.x * cellS) + (cellS / 2.0), buildLimitsStart.y + (grid_pos.y * cellS) + (cellS / 2.0))

func _snap_to_grid(mouse_pos: Vector2):
	selected_part.position = Vector2((round((mouse_pos.x + (cellS / 2.0)) / cellS) * cellS) - (cellS / 2.0), (round((mouse_pos.y + (cellS / 2.0)) / cellS) * cellS) - (cellS / 2.0))
	selected_grid = Vector2(round((mouse_pos.x - (buildLimitsStart.x + (cellS / 2.0))) / cellS), round((mouse_pos.y - (buildLimitsStart.y + (cellS / 2.0))) / cellS))

func _in_zone() -> bool:
	var mousePos = get_viewport().get_mouse_position()
	if mousePos.x > buildLimitsStart.x and mousePos.x < buildLimitsEnd.x and mousePos.y > buildLimitsStart.y and mousePos.y < buildLimitsEnd.y:
		_snap_to_grid(mousePos)
		return true
	return false

func _add_part(part: PartBase):
	part.get_parent().remove_child(part)
	ship.add_child(part)
	ship.parts.append(part)

# comment colour
func _check_limit(id: int, limit: int) -> bool:
	if limit == 0:
		return true
	elif limit == -1:
		return false
	var i = 0
	for part in ship.parts:
		if part.id == id:
			i += 1
			if i == limit:
				return true
	return false

func _check_grid_space() -> bool:
	var part = selected_part
	var x = selected_grid.x
	var y = selected_grid.y
	var w = part.size.x
	var h = part.size.y
	if x + w > 9 or y + h > 9:
		return false
	for i in range(x, x + w):
		for j in range(y, y + h):
			if ship.grid[i][j] != -1:
				return false
	return true

func _clear_all_button():
	for part in ship.parts:
		get_tree().get_first_node_in_group("MoneyManager")._change_money(part.value)
		part.queue_free()
	ship.parts.clear()
	for i in range(0, 9):
		for j in range(0, 9):
			ship.grid[i][j] = -1
	get_tree().get_first_node_in_group("PartSelector")._update_buttons()

func _try_raycast_part() -> PartBase:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_viewport().get_mouse_position()
	var res = space_state.intersect_point(query)
	if res:
		for col in res:
			if col.collider is PartBase:
				return col.collider
	return null

func _check_requirements() -> bool:
	if !_has_part(1):
		$ErrorLabel.text = "Cockpit Missing!"
		$ErrorLabel.modulate = Color(0.6, 0.26, 0.2, 1)
		var tween = get_tree().create_tween()
		tween.tween_property($ErrorLabel, "modulate", Color(0.6, 0.26, 0.2, 0), 1)
		return false
	if !_check_if_all_parts_connected():
		$ErrorLabel.text = "Not all parts connected!"
		$ErrorLabel.modulate = Color(0.6, 0.26, 0.2, 1)
		var tween = get_tree().create_tween()
		tween.tween_property($ErrorLabel, "modulate", Color(0.6, 0.26, 0.2, 0), 1)
		return false

	return true

func _has_part(part_id: int) -> bool:
	for part in ship.parts:
		if part.id == part_id:
			return true
	return false

func _check_if_all_parts_connected() -> bool:
	var connected_parts = []
	var main_part = ship._get_part(1)
	if main_part:
		connected_parts = ship._get_connection_web(main_part)

	print("Parts connected: "+str(connected_parts.size())+"/"+str(_count_parts_in_grid()))
		
	if connected_parts.size() == _count_parts_in_grid():
		return true

	return false

func _count_parts_in_grid() -> int:
	var i = 0
	for row in ship.grid:
		for part in row:
			if part != -1 and part != 100 and part != 101:
				i += 1
	return i
