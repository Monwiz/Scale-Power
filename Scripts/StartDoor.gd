extends AnimatedSprite2D

var timer = 0.5

func _process(delta):
	timer -= delta
	if timer <= 0:
		play() #Close the door
		set_process(false)
