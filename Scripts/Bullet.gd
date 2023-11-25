extends Polygon2D

var speed: int
var looking_right: bool 
var parent_object: Node
func init(parent: Node, right: bool, _speed: int):
	parent_object = parent
	looking_right = right
	speed = _speed
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta):
	if looking_right: position.x += delta*speed
	else: position.x -= delta*speed

func _on_area_2d_body_entered(body):
	if body != parent_object:
		if body.has_method("hurt"):
			body.hurt()
		queue_free()
