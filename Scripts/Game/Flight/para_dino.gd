extends Sprite2D

var tween: Tween

func _ready():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, 500), 20).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	rotation = (randf() - 0.5) * 2
	tween.parallel().tween_property(self, "rotation", 0, 3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(queue_free)

func _exit_tree():
	if tween.is_running():
		tween.stop()
		tween = null