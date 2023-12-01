extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and get_node_or_null("/root/Game/Level") and $/root/Game.get_level_id() != 0:
		visible = !visible
		if $".."/Settings.visible: $".."/Settings._on_close_pressed()
		if visible:
			$/root/Game/Level.process_mode = PROCESS_MODE_DISABLED
			$/root/Game/Audio/Music.stream_paused = true
		else:
			$/root/Game/Level.process_mode = PROCESS_MODE_INHERIT
			$/root/Game/Audio/Music.stream_paused = false

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
