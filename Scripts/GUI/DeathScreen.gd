extends Control

func _on_reset_pressed():
	$/root/Game.restart_level()

func _on_main_menu_pressed():
	$/root/Game.main_menu()
