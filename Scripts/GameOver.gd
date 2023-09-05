extends CanvasLayer

func _ready():
	get_parent().gameover.connect(display_game_over)

func display_game_over(score: float):
	$Score.text = str(score)
	self.visible = true
	get_tree().paused = true
