extends Sprite2D

func _ready():
	position.y = (get_viewport_rect().size.y - texture.get_height()) + 250
	print(position.y)
