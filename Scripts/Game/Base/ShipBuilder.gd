extends Node2D

var ship_parts: Array[PartBase]

var selected_part = null

var selected_grid: Vector2

var ship_grid: Array[Array]

func _ready():
    ship_grid = []
    for i in range(0, 9):
        ship_grid.append([])
        for j in range(0, 9):
            ship_grid[i].append(-1)

func _on_part_selected(part: Part):
    if selected_part:
        selected_part.queue_free()

    var newPart = part.node.instantiate()
    newPart._setup(part)
    add_child(newPart)
    selected_part = newPart

func _process(_delta):
    if selected_part:
        $BuildLight.visible = true
        $BuildLight.position = get_viewport().get_mouse_position()
        selected_part.position = get_viewport().get_mouse_position()

        if _in_zone():
            if Input.is_action_just_pressed("PointerAction"):
                if _check_grid_space():
                    _add_part(selected_part)
                    ship_grid[selected_grid.x][selected_grid.y] = selected_part.id
                    
                    get_tree().get_first_node_in_group("MoneyManager")._try_spend_money(selected_part.value)
                    get_tree().get_first_node_in_group("PartSelector")._update_buttons()

                    selected_part = null
    else:
        $BuildLight.visible = false
        if Input.is_action_just_pressed("PointerAction"):
            pass # will be move part functionality
        if Input.is_action_just_pressed("PointerActionAlt"):
            var focused_part = _try_raycast_part()
            if focused_part != null:
                ship_parts.erase(focused_part)
                get_tree().get_first_node_in_group("MoneyManager")._change_money(focused_part.value)
                focused_part.queue_free()
                get_tree().get_first_node_in_group("PartSelector")._update_buttons()

func _snap_to_grid(mouse_pos: Vector2):
    selected_part.position = Vector2((round((mouse_pos.x + 24) / 48) * 48) - 24, (round((mouse_pos.y + 24) / 48) * 48) - 24)
    selected_grid = Vector2(round((mouse_pos.x - 984) / 48), round((mouse_pos.y - 360) / 48))

func _in_zone() -> bool:
    var mousePos = get_viewport().get_mouse_position()
    if mousePos.x > 960 and mousePos.x < 1392 and mousePos.y > 336 and mousePos.y < 768:
        _snap_to_grid(mousePos)
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

func _check_grid_space() -> bool:
    var part = selected_part
    var x = selected_grid.x
    var y = selected_grid.y
    var w = part.width
    var h = part.height
    if x + w > 9 or y + h > 9:
        return false
    for i in range(x, x + w):
        for j in range(y, y + h):
            if ship_grid[i][j] != -1:
                return false
    return true

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
