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
			if not $Audio/Destruction.playing:
				queue_free()
	elif health <= 0:
		die()
	if modulate.r > 1:
		modulate = Color(modulate.r-16*delta,modulate.g-16*delta,modulate.b-16*delta,modulate.a)
	else: modulate = Color(1,1,1,modulate.a)

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		play_riding_sounds()
	else:
		stop_riding_sounds()
		velocity.y += gravity * delta
	velocity.x = speed * delta * 100
	if not $FreeSpaceChecker.has_overlapping_bodies():
		change_direction()
		
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if (collision.get_normal().x > 0 and $SpriteCenter.scale.x < 0) or (collision.get_normal().x < 0 and $SpriteCenter.scale.x > 0):
			change_direction()
	move_and_slide()
	
func play_riding_sounds():
	$Audio/Riding.stream_paused = false
func stop_riding_sounds():
	$Audio/Riding.stream_paused = true
	
func change_direction():
	speed *= -1
	$SpriteCenter.scale.x *= -1
	$DeathZone.scale.x *= -1
	$FreeSpaceChecker.scale.x *= -1
	
func hurt():
	health -= 1
	modulate = Color(4,4,4)
	$Audio/Hit.play()

func die():
	is_dead = true
	set_physics_process(false)
	collision_layer = 0
	$Audio/Destruction.play()

func _on_death_zone_body_entered(body):
	if body != self and body.has_method("hurt") and not is_dead:
		body.hurt()
