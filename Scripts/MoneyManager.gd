extends Node2D

var money = 0

func _change_money(amount):
	money += amount

func _try_spend_money(amount) -> bool:
	if money >= amount:
		money -= amount
		return true
	else:
		return false