extends Area2D

@export var bullets: int
var real_pos_y: float

func _ready():
	real_pos_y = position.y
	
func _process(_delta):
	position.y = real_pos_y + 2*sin(2*$/root/Game.get_timer_seconds())

func _on_body_entered(body):
	if body.has_method("add_bullets"):
		body.add_bullets(bullets)
		queue_free()
