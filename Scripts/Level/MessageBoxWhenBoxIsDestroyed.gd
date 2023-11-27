extends ColorRect

func _process(_delta):
	if !get_node_or_null("/root/Game/Level/Objects/Box"):
		$Label.text = "You can change size of some objects.\nLet's try to scale the box up. Move it\nto the green zone and drag any corner.\nPress   for restart."
		$ColorRect.position.x = 50
		set_process(false)
