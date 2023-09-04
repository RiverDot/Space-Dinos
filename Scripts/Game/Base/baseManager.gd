extends Node2D

func _ready():
	get_tree().get_first_node_in_group("MoneyManager")._update_labels()

func _on_liftOff_pressed():
	get_tree().get_first_node_in_group("GameScene")._change_scene(1)