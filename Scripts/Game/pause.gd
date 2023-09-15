extends CanvasLayer

func _on_resume_pressed():
	get_parent()._set_pause(false)

func _on_options_pressed():
	get_tree().get_first_node_in_group("Options")._set_open(true)

func _on_menu_pressed():
	get_tree().get_first_node_in_group("Root")._change_scene(0)

func _on_to_base_pressed():
	get_tree().get_first_node_in_group("GameScene")._change_scene(0)
	get_parent()._set_pause(false)

func _update_buttons(scene_id):
	if scene_id == 0:
		$Control/ToBaseButton.visible = false
	else:
		$Control/ToBaseButton.visible = true
