extends Node2D

var paused: bool = false

func _ready():
	get_tree().paused = false
	
func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		_set_pause(!paused)

func _on_resume_pressed():
	_set_pause(false)

func _on_menu_pressed():
	get_tree().get_first_node_in_group("Root")._change_scene(0)

func _set_pause(_paused):
	paused = _paused
	if paused:
		get_tree().paused = true
		$PauseScreen.visible = true
	else:
		get_tree().paused = false
		$PauseScreen.visible = false
