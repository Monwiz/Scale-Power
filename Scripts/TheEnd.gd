extends Node

@export var needed_number_of_destroyed_enemies: int
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
		body.set_physics_process(false)
		body.set_process(false)
		$Door.play() #Close the door
		#$/root/Game.load_next_level()
