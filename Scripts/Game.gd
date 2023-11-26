extends Node2D

const LAST_LEVEL_ID = 2
var timer_seconds: float = 0
var level_id = 0
var is_timer_on: bool = true

func get_timer_seconds()->float: return timer_seconds
func set_timer(value: bool): is_timer_on = value
func reset_timer(): timer_seconds = 0

func _ready():
	load_level(1)
	$Audio/Music/Menu.stop()
	$Audio/Music/N1.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_timer_on: timer_seconds += delta

func load_level(number: int):
	if number <= LAST_LEVEL_ID:
		level_id = number
		if get_node_or_null("Level"):
			$Level.name = "is_queued_for_deletion"
			$is_queued_for_deletion.queue_free()
		var level = load("res://Scenes/level_"+str(number)+".tscn")
		call_deferred("add_child", level.instantiate())
	
func load_next_level():
	load_level(level_id+1)
