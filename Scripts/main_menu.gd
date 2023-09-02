extends Node2D

func _on_start_pressed():
	get_tree().get_first_node_in_group("Root")._change_scene(1)

func _on_options_pressed():
	get_tree().get_first_node_in_group("Options")._set_open(true)

func _on_quit_pressed():
	get_tree().quit()
