extends Control

@export var part_button: PackedScene

var button_list: Array[PartButton]

@export var parts_list: Array[Part]

enum PartCategory { 
	CORE = 1,
	HULL = 2,
	MOBILITY = 4,
	FUEL = 8,
	DEFENCE = 16
}

func _ready():
	for part in parts_list:
		var button = part_button.instantiate()
		button._setup(part)
		button.pressed.connect(Callable(_on_part_selected).bind(part))
		button_list.append(button)
		$PartsGrid.add_child(button)
	_update_buttons()

func _on_part_selected(part):
	get_tree().get_first_node_in_group("ShipBuilder")._on_part_selected(part)

func _update_buttons():
	for button in button_list:
		var part = button.part
		button._set_status(part.cost <= get_tree().get_first_node_in_group("MoneyManager").money, get_tree().get_first_node_in_group("ShipBuilder")._check_limit(button.part.id, button.part.limit))

