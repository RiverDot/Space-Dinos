extends Node2D

var stars_top: Sprite2D
var stars_bottom: Sprite2D

func _ready():
	stars_top = $Stars1
	stars_bottom = $Stars2

func _physics_process(_delta):
	var scroll = get_parent().scroll_amount
	stars_top.position.y += scroll
	stars_bottom.position.y += scroll

	if stars_bottom.position.y > 540 + 1100:
		stars_bottom.position.y -= 2200
		_flip_stars()
	elif stars_top.position.y < 540 - 1100:
		stars_top.position.y += 2200
		_flip_stars()

	var percent = get_parent()._get_percent_to_goal()
	var ramp = 1
	if percent > 0.3:
		ramp -= 0.2 * ((percent - 0.3) / 0.4)
	elif percent > 0.7:
		ramp -= 0.2

	stars_top.texture.color_ramp.set_offset(0, ramp)

func _flip_stars():
	var temp_stars = stars_top
	stars_top = stars_bottom
	stars_bottom = temp_stars
