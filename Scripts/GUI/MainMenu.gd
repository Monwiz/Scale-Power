extends Control


func _on_new_game_pressed():
	$/root/Game.reset_game()
	$/root/Game.load_level(1)

func _on_load_game_pressed():
	$/root/Game.load_level()
	
func _on_select_level_pressed():
	$/root/Game/GUI/SelectLevel.visible = true
	
func _on_settings_pressed():
	$"../Settings".visible = true
	
func _on_exit_pressed():
	get_tree().quit()
