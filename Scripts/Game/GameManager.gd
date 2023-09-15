extends Node2D

var paused: bool = false

var total_money_earned = 0

var total_loses = 0

var total_time_spent = 0

var total_distance_travelled = 0

var record_height = 0

func _ready():
	get_tree().paused = false

func _process(_delta):

	if get_tree().paused == false:
		total_time_spent += _delta

	if Input.is_action_just_pressed("Pause") && get_tree().get_first_node_in_group("Options").open == false:
		if get_tree().get_first_node_in_group("FlightScreen") != null:
			if get_tree().get_first_node_in_group("FlightScreen").game_over == true:
				return
		_set_pause(!paused)

func _set_pause(_paused):
	paused = _paused
	if paused:
		get_tree().paused = true
		$PauseScreen.visible = true
	else:
		get_tree().paused = false
		$PauseScreen.visible = false
