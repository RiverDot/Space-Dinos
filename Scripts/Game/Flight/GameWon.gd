extends CanvasLayer

func _on_return_to_base():
	get_tree().get_first_node_in_group("GameScene")._change_scene(0)
	get_parent().get_parent().get_parent()._set_pause(false)

func _on_game_won():
	visible = true

	var game_manager = get_tree().get_first_node_in_group("GameManager")

	$Control/TotalMoney.text = "Total money earned: $" + str(game_manager.total_money_earned)

	$Control/TotalLoses.text = "Ships crashed: " + str(game_manager.total_loses)

	$Control/TotalTime.text = "Total time spent: " + str(snapped(game_manager.total_time_spent, 2) ) + " seeconds"

	$Control/TotalDistance.text = "Total distance travelled: " + str(snapped(game_manager.total_distance_travelled, 2))