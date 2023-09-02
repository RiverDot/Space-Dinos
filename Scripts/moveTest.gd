extends Sprite2D

var dir = Vector2.RIGHT

var timer = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	timer -= _delta
	if timer <= 0:
		dir = -dir
		timer += 1.5
	
	translate(dir * 400 * _delta)
