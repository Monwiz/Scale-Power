extends Node

@export var level_id: int
@export var needed_number_of_destroyed_enemies: int
@export_range(-10,10) var player_movement_time: float
var number_of_destroyed_enemies = 0
@onready var number_of_enemies = len(get_tree().get_nodes_in_group("Enemies"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var old_number_of_enemies = len(get_tree().get_nodes_in_group("Enemies"))
	if old_number_of_enemies != number_of_enemies:
		number_of_destroyed_enemies += number_of_enemies - old_number_of_enemies
		number_of_enemies = old_number_of_enemies
		if number_of_destroyed_enemies >= needed_number_of_destroyed_enemies:
			$Door.play_backwards() #Open the door
			$CollisionShape2D.disabled = true

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		set_process(false)
		if player_movement_time != 0: body.move(player_movement_time, true)
		$Door.play() #Close the door
		$/root/Game.unlock_level(level_id)
		$/root/Game.end_level()
