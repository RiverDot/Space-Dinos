extends Control

@export var part_button: PackedScene

var button_list: Array[PartButton]

var parts_list: Array

enum PartCategory { 
	CORE = 1,
	HULL = 2,
	MOBILITY = 4,
	FUEL = 8,
	DEFENCE = 16
}

func _ready():

	parts_list = _dir_contents("res://Resources/Data/Parts/")

	get_tree().get_first_node_in_group("ShipManager")._load_ship(get_tree().get_first_node_in_group("ShipBuilder"))
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

