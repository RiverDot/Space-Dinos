extends Node2D

var money = 200

func _change_money(amount):
	money += amount
	_update_labels()

func _try_spend_money(amount) -> bool:
	if money >= amount:
		money -= amount
		_update_labels()
		return true
	else:
		return false

func _update_labels():
	for label in get_tree().get_nodes_in_group("Money"):
		label.text = str(money)