extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and $/root/Game/Level and $/root/Game.get_level_id() != 0:
		visible = !visible
		
		$/root/Game/Level.process_mode = PROCESS_MODE_DISABLED if visible else PROCESS_MODE_INHERIT
		$/root/Game/Audio/Music.stream_paused = visible

func _on_settings_pressed():
	$"../Settings".visible = true
	
func _on_exit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	$/root/Game.main_menu()

func _on_reset_pressed():
	$/root/Game.restart_level()

func _on_resume_pressed():
	visible = false
	$/root/Game/Level.process_mode = PROCESS_MODE_INHERIT
	$/root/Game/Audio/Music.stream_paused = false
