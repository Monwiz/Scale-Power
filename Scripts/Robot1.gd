extends CharacterBody2D


@export var speed = 30.0
const JUMP_VELOCITY = -400.0
@export_range(1,50) var health: int = 3
var is_dead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	if is_dead:
		modulate.a -= 8*delta
		if modulate.a <= 0:
			queue_free()
	if modulate.r > 1:
		modulate = Color(modulate.r-16*delta,modulate.g-16*delta,modulate.b-16*delta,modulate.a)
	else: modulate = Color(1,1,1,modulate.a)
	if health <= 0:
		die()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = speed * delta * 100
	if not $FreeSpaceChecker.has_overlapping_bodies():
		change_direction()
		
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if (collision.get_normal().x > 0 and $SpriteCenter.scale.x < 0) or (collision.get_normal().x < 0 and $SpriteCenter.scale.x > 0):
			change_direction()
	move_and_slide()

func change_direction():
	speed *= -1
	$SpriteCenter.scale.x *= -1
	$DeathZone.scale.x *= -1
	$FreeSpaceChecker.scale.x *= -1
	
func hurt():
	health -= 1
	modulate = Color(4,4,4)

func die():
	is_dead = true
	set_physics_process(false)
	collision_layer = 0

func _on_death_zone_body_entered(body):
	if body != self and body.has_method("hurt"):
		body.hurt()
