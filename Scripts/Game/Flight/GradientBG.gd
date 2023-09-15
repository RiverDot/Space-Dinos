extends Sprite2D

@export var sky_gradient: Gradient

var flightScene

var percent: float = 0.01

func _ready():
	flightScene = get_tree().get_first_node_in_group("FlightScreen")

func _process(_delta):
	var pointCount = texture.gradient.get_point_count()
	for i in range(pointCount - 1):
		texture.gradient.remove_point(0)

	var progress: float = flightScene.height / (flightScene.height_goal / flightScene.map_size_multiplier)

	if progress > 1:
		progress = 1
	elif progress < 0:
		progress = 0

	progress = 1 - progress

	var bottom = progress - (percent / 2)
	var top = progress + (percent / 2)
	if bottom < 0:
		var move = bottom * -1
		bottom = 0
		top = top + move
	elif top > 1:
		var move = top - 1
		top = 1
		bottom = bottom - move

	texture.gradient.set_color(0, sky_gradient.sample(top))
	texture.gradient.add_point(0, sky_gradient.sample(bottom))

	var sky_point_count = sky_gradient.get_point_count()
	for i in range(sky_point_count):
		var point_offset = sky_gradient.get_offset(i)
		if point_offset > bottom && point_offset < top:
			texture.gradient.add_point((point_offset - bottom)/percent, sky_gradient.get_color(i))

	

	