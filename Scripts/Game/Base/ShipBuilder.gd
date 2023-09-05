extends Node2D

var ship_parts: Array[PartBase]

var selected_part = null

func _on_part_selected(part: Part):
	if selected_part:
		selected_part.queue_free()

	var newPart = part.node.instantiate()
	newPart._setup(part)
	add_child(newPart)
	selected_part = newPart

func _process(_delta):
	if selected_part:
		selected_part.position = get_viewport().get_mouse_position()

		if Input.is_action_just_pressed("PointerAction"):
			if _in_zone():
				_add_part(selected_part)
				
				get_tree().get_first_node_in_group("MoneyManager")._try_spend_money(selected_part.value)
				get_tree().get_first_node_in_group("PartSelector")._update_buttons()

				selected_part = null
	else:
		if Input.is_action_just_pressed("PointerAction"):
			pass # will be move part functionality
		if Input.is_action_just_pressed("PointerActionAlt"):
			var focused_part = _try_raycast_part()
			if focused_part != null:
				ship_parts.erase(focused_part)
				get_tree().get_first_node_in_group("MoneyManager")._change_money(focused_part.value)
				focused_part.queue_free()
				get_tree().get_first_node_in_group("PartSelector")._update_buttons()

func _in_zone() -> bool:
	var mousePos = get_viewport().get_mouse_position()
	if mousePos.x > 960 and mousePos.x < 1400 and mousePos.y > 400 and mousePos.y < 800:
		return true
	return false

func _add_part(part: PartBase):
	part.get_parent().remove_child(part)
	$Ship.add_child(part)
	ship_parts.append(part)

func _check_limit(id: int, limit: int) -> bool:
	if limit == 0:
		return true
	var i = 0
	for part in ship_parts:
		if part.id == id:
			i += 1
			if i == limit:
				return true
	return false

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
