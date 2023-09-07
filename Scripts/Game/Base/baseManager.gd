extends Node2D

func _ready():
	get_tree().get_first_node_in_group("MoneyManager")._update_labels()

func _on_liftOff_pressed():
	if get_tree().get_first_node_in_group("ShipBuilder")._check_requirements():
		get_tree().get_first_node_in_group("ShipManager")._save_ship()
		get_tree().get_first_node_in_group("GameScene")._change_scene(1)
