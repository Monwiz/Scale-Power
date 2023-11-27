extends AudioStreamPlayer

const menu = preload("res://Audio/Music/menu.wav")
const n1 = preload("res://Audio/Music/music.wav")
var music_id: int = -1

func _ready():
	set_music_id(0)

func set_music_id(number: int):
	if music_id != number:
		music_id = number
		match music_id:
			-1:
				stream = null
			0:
				stream = menu
			1:
				stream = n1
		play()
	elif stream_paused:
		play()
		
func get_music_id() -> int: return music_id
