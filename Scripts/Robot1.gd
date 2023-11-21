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
	if is_on_ceiling():
		speed *= -1
		scale.x *= -1
		up_direction.x *= -1
	# Handle Jump.
	#if is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = speed

	move_and_slide()

func hurt(damage: int = 1):
	health -= damage
	modulate = Color(4,4,4)

func die():
	is_dead = true
	set_physics_process(false)
	collision_layer = 0

func _on_area_2d_body_entered(body):
	if body != self and body.has_method("hurt"):
		body.hurt(100)
