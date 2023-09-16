extends Button

class_name PartButton

var part: Part

func _ready():
	pressed.connect(Callable(_play_sound))

func _setup(set_part: Part):
	part = set_part
	text = part.name

func _set_status(can_buy: bool, maxed: bool):
	if maxed:
		disabled = true
		$CostLabel.clear()
		$CostLabel.push_paragraph(1)
		$CostLabel.push_color(Color.WHITE)
		$CostLabel.push_bold()
		$CostLabel.append_text("MAXED")
	else:
		if can_buy:
			disabled = false
			$CostLabel.clear()
			$CostLabel.push_paragraph(1)
			$CostLabel.push_color(Color.WHITE)
			$CostLabel.push_bold()
			$CostLabel.append_text("$" + str(part.cost))
		else:
			disabled = true
			$CostLabel.clear()
			$CostLabel.push_paragraph(1)
			$CostLabel.push_color(Color(0.6, 0.26, 0.2))
			$CostLabel.push_bold()
			$CostLabel.append_text("$" + str(part.cost))

func _play_sound():
	get_tree().get_first_node_in_group("SFXPlayer")._play_sound(load("res://Assets/Audio/SFX/press.wav"), 1, randf() * 0.2 + 0.9)