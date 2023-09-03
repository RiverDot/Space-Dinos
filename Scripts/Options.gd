extends CanvasLayer

var open: bool = false

func _set_open(value: bool):
	open = value
	visible = open
