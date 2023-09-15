extends StaticBody2D

class_name PartBase

var id: int

var value: int

var size: Vector2

var grid_pos: Vector2

var tween: Tween

var is_broken: bool = false

var category: Enums.PartCategory

func _setup(part: Part):
	id = part.id
	value = part.cost
	size = part.size
	category = part.category as Enums.PartCategory

func _damage(_damage_value: int):
	get_tree().get_first_node_in_group("PlayerShip")._destroy_part(self)

func _get_sprite():
	return $Sprite

func _get_shape():
	return $Shape

func _break_part(part_pos):
	print("break part")
	global_position = part_pos
	is_broken = true
	collision_layer = 0
	collision_mask = 0
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, 500), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	var move_amount = (randf() - 0.5) * 200
	tween.parallel().tween_method(_move_block, 0, move_amount, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self, "rotation", (randf() - 0.5) * 2, 0.6).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(queue_free)

	for group in get_groups():
		remove_from_group(group)
	get_tree().get_first_node_in_group("PlayerShip")._update_ship()

func _move_block(_value: float):
	position.x += _value

func _exit_tree():
	if is_broken:
		if tween.is_running():
			tween.stop()
			tween = null
