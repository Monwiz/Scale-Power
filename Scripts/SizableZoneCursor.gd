extends Polygon2D

func _process(delta):
	global_position = get_global_mouse_position()-Vector2.ONE
