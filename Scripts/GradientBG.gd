extends Sprite2D

func _ready():
	position.y = (get_viewport_rect().size.y - texture.get_height()) + 480
	print(position.y)
