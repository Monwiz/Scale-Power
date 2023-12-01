extends Polygon2D

func _process(_delta):
	global_position = (7*global_position+get_global_mouse_position()-Vector2.ONE)/8
