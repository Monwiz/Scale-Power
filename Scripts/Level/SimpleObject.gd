extends RigidBody2D

func _process(_delta):
	linear_velocity.x = clamp(linear_velocity.x, -1, 1) #dirty hack, I'm not able to fix the problem behind it
