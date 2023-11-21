extends CharacterBody2D


const SPEED = 125.0
const JUMP_VELOCITY = -220.0
@export_range(1,50) var health: int = 3
@export_range(0,100) var bullets: int
var timer = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_small: bool = false
var is_dead = false
var can_move_vertical: bool = true
var moving_vertical: bool = false
@export var can_interact_with_back_layer: bool
#var on_the_backside: bool = false

func _process(delta):
	timer -= delta
		
	if is_dead:
		$Sprite.modulate.a -= 8*delta
		if $Sprite.modulate.a <= 0:
			set_process(false)
	if $Sprite.modulate.r > 1:
		$Sprite.modulate = Color($Sprite.modulate.r-16*delta,$Sprite.modulate.g-16*delta,$Sprite.modulate.b-16*delta,$Sprite.modulate.a)
	else: $Sprite.modulate = Color(1,1,1,$Sprite.modulate.a)
	if health <= 0:
		die()
		
	if moving_vertical:
		if is_small:
			scale.x = max(scale.x-delta, 0.5)
			scale.y = max(scale.y-delta, 0.5)
			$Camera2D.zoom = Vector2(2,2) / scale
			if scale.x == 0.5:
				$Sprite.play("back")
				collision_mask = 3 if can_interact_with_back_layer else 2
				collision_layer = 2
				$Bullet/Area2D.collision_mask = 3
				z_index = -1
				$Bullet.z_index = -3
				
				$Bullet.scale = scale
				moving_vertical = false
				set_physics_process(true)
		else:
			scale.x = min(scale.x+delta, 1)
			scale.y = min(scale.y+delta, 1)
			$Camera2D.zoom = Vector2(2,2) / scale
			if scale.x == 1:
				$Sprite.play("front")
				collision_mask = 1
				collision_layer = 1
				$Bullet/Area2D.collision_mask = 1
				z_index = 0
				$Bullet.z_index = -1
				
				$Bullet.scale = scale
				moving_vertical = false
				set_physics_process(true)
	elif Input.is_action_just_pressed("shoot") and bullets > 0 and\
	not $Sprite.animation in ["front","back"] and timer < 0:
		timer = 0.25
		bullets -= 1
		var bullet = $Bullet.duplicate()
		var looking_right = $Sprite.animation in ["moving_right","right"]
		bullet.init(looking_right, 500*scale.x, true)
		bullet.global_position = Vector2($Bullet.global_position.x + scale.x * (9 if looking_right else -9), $Bullet.global_position.y)
		get_parent().add_child(bullet)

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var hdirection = Input.get_axis("ui_left", "ui_right")
	var vdirection = Input.get_axis("ui_up", "ui_down")
	if can_move_vertical and vdirection:
		$Sprite.play("back" if vdirection < 0 else "front")
		velocity.x = 0
		if is_small != (vdirection < 0):
			if $"../BackLayer".get_cell_tile_data(1, Vector2(round(position.x/8),round((position.y+5)/8))):
				if vdirection < 0:
					is_small = true
					$Sprite.play("moving_back")
				else:
					is_small = false
					$Sprite.play("moving_front")
				moving_vertical = true
				set_physics_process(false)
				
	elif hdirection and not moving_vertical:
		velocity.x = hdirection * SPEED * scale.x
		$Sprite.play("moving_left" if hdirection < 0 else "moving_right")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * scale.x)
		if $Sprite.animation == "moving_left": $Sprite.play("left")
		elif $Sprite.animation == "moving_right": $Sprite.play("right")

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * scale.y
		$Sprite.stop()
	else:
		# Handle Jump.
		if Input.is_action_just_pressed("jump") and not moving_vertical:
			velocity.y += JUMP_VELOCITY * scale.y
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-200*collision.get_normal())#15*position.direction_to(collision.get_collider().position))

func hurt(damage: int = 1):
	health -= damage
	$Sprite.modulate = Color(4,4,4)

func die():
	is_dead = true
	set_physics_process(false)
	collision_layer = 0
	$GPUParticles2D.emitting = true

func add_bullets(value: int): bullets += value
