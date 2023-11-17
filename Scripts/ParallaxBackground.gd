extends ParallaxBackground

func _process(delta):
	scroll_base_offset = Vector2(get_viewport().size)*$/root/Game/Area2D/Player/Camera2D.zoom/-2
	for child in get_children():
		child.motion_offset = Vector2(get_viewport().size)/4
