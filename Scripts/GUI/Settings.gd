extends Control

func _on_sfx_volume_value_changed(value):
	if value == -20: AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		AudioServer.set_bus_volume_db(2, value)

func _on_music_volume_value_changed(value):
	if value == -25: AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_volume_db(1, value)

func _on_close_pressed():
	$/root/Game.save_data()
	visible = false
	$".."/MainMenu/Panel/VBoxContainer/Settings.set_pressed_no_signal(false)
	$".."/PauseMenu/Panel/VBoxContainer/Settings.set_pressed_no_signal(false)
