extends CPUParticles2D

var time = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time = time - delta
	if time < 0 :
		queue_free()
	
