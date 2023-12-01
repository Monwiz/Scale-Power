extends Node

const version = "1"
const LAST_LEVEL_ID = 3

var current_level_of_save: int
var unlocked_levels: int
var total_time: float = 0
var best_time: float = -1
var timer_seconds: float = 0
var level_id = 0
var hiding_animation: float = -3

var is_timer_on: bool = false
var is_hiding_screen: bool = false
var is_showing_screen: bool = false
var is_replaying: bool
var is_finished: bool

func get_timer_seconds()->float: return timer_seconds
func get_level_id()->int: return level_id

func _ready():
	if FileAccess.file_exists("user://.save"):
		var save = FileAccess.get_file_as_string("user://.save").split("\n")
		$GUI/Settings/Panel/VBoxContainer/MusicVolume.value = int(save[1])
		$GUI/Settings/Panel/VBoxContainer/SFXVolume.value = int(save[2])
		current_level_of_save = int(save[3])
		unlocked_levels = int(save[4])
		total_time = int(save[5])
		best_time = int(save[6])
		
		if unlocked_levels > 0:
			$GUI/SelectLevel.unlock_levels(unlocked_levels)
			$GUI/MainMenu/Panel/VBoxContainer/SelectLevel.disabled = false
		if current_level_of_save > 1 and current_level_of_save <= LAST_LEVEL_ID:
			$GUI/MainMenu/Panel/VBoxContainer/LoadGame.disabled = false
				
func save_data():
	FileAccess.open("user://.save", FileAccess.WRITE).store_string(
		version + "\n" +
		str($GUI/Settings/Panel/VBoxContainer/MusicVolume.value) + "\n" +
		str($GUI/Settings/Panel/VBoxContainer/SFXVolume.value) + "\n" +
		str(current_level_of_save) + "\n" +
		str(unlocked_levels) + "\n" +
		str(total_time) + "\n" +
		str(best_time)
	)

func _process(delta):
	if is_timer_on: timer_seconds += delta
	if is_hiding_screen:
		hiding_animation = min(hiding_animation + delta*3, -1)
		if hiding_animation == -1:
			is_hiding_screen = false
			$GUI/DeathScreen.visible = false
			$GUI/PauseMenu.visible = false
			if level_id != 0:
				$GUI/MainMenu.visible = false
				$GUI/Settings.visible = false
				$GUI/SelectLevel.visible = false
				$GUI/HUD/BulletsNumber.text = "0"
				$GUI/HUD.visible = true
				unload_level()
				var level = load("res://Scenes/level_"+str(level_id)+".tscn")
				call_deferred("add_child", level.instantiate())
				match level_id:
					1, 2:
						$Audio/Music.set_music_id(1)
				is_timer_on = true
			else:
				unload_level()
				$GUI/MainMenu.visible = true
				$GUI/HUD.visible = false
				if is_replaying:
					$GUI/SelectLevel.visible = true
					is_replaying = false
				if is_finished:
					$GUI/EndScreen.visible = true
					is_finished = false
				$Audio/Music.set_music_id(0)
				timer_seconds = 0
			is_showing_screen = true
			$GUI/Rect/ShowingSFXCenter/Showing.play()
	elif is_showing_screen:
		hiding_animation = min(hiding_animation + delta*3, 1)
		if hiding_animation == 1:
			hiding_animation = -3
			is_showing_screen = false
	$GUI/Rect.size = Vector2(get_viewport().size.x*3, get_viewport().size.y)
	$GUI/Rect.position.x = $GUI/Rect.size.x * hiding_animation/3
				
func unload_level():
	if get_node_or_null("Level"):
		#$Level.name = "is_free"
		$Level.free()
	
func load_level(number: int = current_level_of_save, replay: bool = false):
	level_id = number
	is_replaying = replay
	is_hiding_screen = true
	$GUI/Rect/HidingSFXCenter/Hiding.play()

func unlock_level(number: int):
	unlocked_levels = max(unlocked_levels, number)
	$GUI/SelectLevel.unlock_levels(number)

func end_level():
	is_timer_on = false
	if is_replaying:
		main_menu()
	else:
		total_time += timer_seconds
		timer_seconds = 0
		$/root/Game.unlock_level(level_id)
		current_level_of_save = level_id+1
		if current_level_of_save <= LAST_LEVEL_ID:
			$GUI/MainMenu/Panel/VBoxContainer/LoadGame.disabled = false
			load_level(current_level_of_save)
		else:
			main_menu()
			is_finished = true
			if best_time == -1:
				$GUI/EndScreen/Panel/Time.text = "You completed the game in %f minutes %.2f seconds." % [total_time/60, total_time]
				best_time = total_time
			elif total_time < best_time:
				$GUI/EndScreen/Panel/Time.text = "You have new record - %f m %.2f s. The last one was %f m %.2f s." % [total_time/60,total_time, best_time/60,best_time]
				best_time = total_time
			else:
				$GUI/EndScreen/Panel/Time.text = "You finished in %f m %.2f s. Best time is %f m %.2f s." % [total_time/60,total_time, best_time/60,best_time]
			$GUI/MainMenu/Panel/VBoxContainer/LoadGame.disabled = true
	save_data()

func restart_level():
	total_time += timer_seconds
	load_level(level_id, is_replaying)
	
	
func reset_game():
	total_time = 0
	current_level_of_save = 0
	$GUI/MainMenu/Panel/VBoxContainer/LoadGame.disabled = true

func main_menu():
	level_id = 0
	is_hiding_screen = true
	$GUI/Rect/HidingSFXCenter/Hiding.play()
	timer_seconds = 0
