extends CanvasLayer

var tween: Tween

func _ready():
	get_parent().gameover.connect(display_game_over)

func display_game_over(score: float):
	$Control/Score.text = "Height reached: " + str(round_to_dec(score, 2)) + "km"
	$Control/MoneyEarned.text = "Money earned: $" + str(get_tree().get_first_node_in_group("FlightScreen").money_earned)
	self.visible = true
	tween = get_tree().create_tween()
	tween.tween_interval(1)
	tween.tween_callback(_pause_scene)

func _pause_scene():
	pass
	#get_tree().paused = true

func _on_return_to_base():
	get_tree().get_first_node_in_group("GameScene")._change_scene(0)
	get_parent().get_parent().get_parent()._set_pause(false)

func _exit_tree():
	if tween:
		if tween.is_running():
			tween.stop()
			tween = null

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
