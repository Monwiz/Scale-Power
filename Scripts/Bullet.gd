extends Polygon2D

var speed: int
var ignore_player: bool
var looking_right: bool 
func init(right: bool, _speed: int, ignoreplayer = false):
	looking_right = right
	speed = _speed
	ignore_player = ignoreplayer
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if looking_right: position.x += delta*speed
	else: position.x -= delta*speed


func _on_area_2d_body_entered(body):
	if (body.get_name() != "Player" if ignore_player else true):
		if body.has_method("hurt"):
			body.hurt()
		queue_free()
