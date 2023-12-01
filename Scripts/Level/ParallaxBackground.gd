extends ParallaxBackground

func _process(_delta):
	if get_node_or_null("/root/Game/Level/Player/Camera2D"):
		scroll_base_offset = Vector2(get_viewport().size)*$/root/Game/Level/Player/Camera2D.zoom/-2
	for child in get_children():
		child.motion_offset = Vector2(get_viewport().size)/4
