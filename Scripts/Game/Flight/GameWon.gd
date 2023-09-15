extends CanvasLayer

func _on_return_to_base():
	get_tree().get_first_node_in_group("GameScene")._change_scene(0)
	get_parent().get_parent().get_parent()._set_pause(false)

func _on_game_won():
	visible = true