extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("CheatMenu"):
		if not is_visible():
			show()
		else:
			hide()

func _on_money_cheat():
	var money_manager = get_tree().get_first_node_in_group("MoneyManager")
	if money_manager != null:
		money_manager._change_money(1000)
		money_manager._update_labels()

func _on_fuel_cheat():
	var rocket_ship = get_tree().get_first_node_in_group("PlayerShip")
	if rocket_ship != null:
		rocket_ship.infFuelCheat = !rocket_ship.infFuelCheat

func _on_invincible_cheat():
	var rocket_ship = get_tree().get_first_node_in_group("PlayerShip")
	if rocket_ship != null:
		rocket_ship.invincibleCheat = !rocket_ship.invincibleCheat