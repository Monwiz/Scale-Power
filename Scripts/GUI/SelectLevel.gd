extends Control

func unlock_levels(to_id: int):
	var levels = $Panel/VBoxContainer/GridContainer.get_children()
	for x in range(to_id):
		levels[x].disabled = false

func _on_n_1_pressed(): $/root/Game.load_level(1, true)
func _on_n_2_pressed(): $/root/Game.load_level(2, true)
func _on_n_3_pressed(): $/root/Game.load_level(3, true)

func _on_cancel_pressed():
	visible = false
	$".."/MainMenu/Panel/VBoxContainer/SelectLevel.set_pressed_no_signal(false)
