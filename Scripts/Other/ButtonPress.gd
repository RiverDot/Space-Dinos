extends Button

func _ready():
	pressed.connect(Callable(_play_sound))

func _play_sound():
	get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/press.wav"), 1, randf() * 0.2 + 0.9)