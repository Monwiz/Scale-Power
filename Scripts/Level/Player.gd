extends CharacterBody2D

const SPEED = 125.0
const JUMP_VELOCITY = -220.0
@export_range(0,100) var bullets: int
var timer = 0
@export_range(-10,10) var movement_time: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_small: bool = false
var is_dead = false
var can_move_vertical: bool = true
var moving_vertical: bool = false
@export var can_interact_with_front_layer: bool
var no_return_of_process: bool = false #For level end animation

func _ready():
	$Audio/Step.play(0) #Set playback position to 0
	$Audio/Step.stream_paused = true
	if movement_time != 0:
		set_physics_process(false)
		$Sprite.animation = "moving_right" if movement_time > 0 else "moving_left"
		$Sprite.play()

func _process(delta):
	timer -= delta
		
	if Input.is_action_just_pressed("restart"):
		$/root/Game.restart_level()
		
	if is_dead:
		$Sprite.modulate.a -= 8*delta
		if $Sprite.modulate.a <= 0:
			$/root/Game/GUI/DeathScreen.modulate.a = min($/root/Game/GUI/DeathScreen.modulate.a+delta,1)
			
	if $Sprite.modulate.r > 1:
		$Sprite.modulate = Color($Sprite.modulate.r-16*delta,$Sprite.modulate.g-16*delta,$Sprite.modulate.b-16*delta,$Sprite.modulate.a)
	else: $Sprite.modulate = Color(1,1,1,$Sprite.modulate.a)
		
	if movement_time != 0:
		play_step_sounds()
		if movement_time > 0:
			move_local_x(SPEED * scale.x / 2 * delta)
			movement_time = max(movement_time-delta, 0)
		else:
			move_local_x(SPEED * scale.x / -2 * delta)
			movement_time = min(movement_time+delta, 0)
			
		if movement_time == 0:
			if no_return_of_process:
				set_process(false)
			else:
				set_physics_process(true)
			stop_step_sounds()
		return
	if moving_vertical:
		$Camera2D.offset.y = -32 * scale.y
		$Camera2D.zoom = Vector2(2,2) / scale
		if is_small:
			scale.x = max(scale.x-delta, 0.5)
			scale.y = max(scale.y-delta, 0.5)
			if scale.x == 0.5:
				$Sprite.play("back")
				collision_mask = 3 if can_interact_with_front_layer else 2
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
		shoot()

func _physics_process(delta):
	var hdirection = Input.get_axis("ui_left", "ui_right")
	var vdirection = Input.get_axis("ui_up", "ui_down")
	if can_move_vertical and vdirection:
		velocity.x = 0
		if is_small != (vdirection < 0) and is_on_bridge():
			if vdirection < 0:
				is_small = true
				$Sprite.play("moving_back")
			else:
				is_small = false
				$Sprite.play("moving_front")
			moving_vertical = true
			set_physics_process(false)
			play_step_sounds()
		else: 
			$Sprite.play("back" if vdirection < 0 else "front")
			stop_step_sounds()
	elif hdirection and not moving_vertical:
		velocity.x = hdirection * SPEED * scale.x
		$Sprite.play("moving_left" if hdirection < 0 else "moving_right")
		play_step_sounds()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * scale.x)
		if $Sprite.animation == "moving_left": $Sprite.play("left")
		elif $Sprite.animation == "moving_right": $Sprite.play("right")
		stop_step_sounds()
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump") and not moving_vertical:
			velocity.y += JUMP_VELOCITY * scale.y
			$Audio/Jump.play()
	else:
		velocity.y += gravity * delta * scale.y
		$Sprite.stop()
		stop_step_sounds()
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-200*collision.get_normal())
			
	if global_position.y > 260: die()
	
func is_on_bridge() -> bool:
	return $"../BackLayer".get_cell_tile_data(
		1, Vector2(round(position.x/8),round((position.y+5)/8))) != null
	
func play_step_sounds():
	$Audio/Step.stream_paused = false
func stop_step_sounds():
	if $Audio/Step.playing:
		$Audio/Step.play(0) #Set playback position to 0
		$Audio/Step.stream_paused = true
	
func shoot():
	timer = 0.25
	bullets -= 1
	var bullet = $Bullet.duplicate()
	var looking_right = $Sprite.animation in ["moving_right","right"]
	bullet.init(self, looking_right, 500*scale.x)
	bullet.global_position = Vector2($Bullet.global_position.x + scale.x * (9 if looking_right else -9), $Bullet.global_position.y)
	get_parent().add_child(bullet)
	$Audio/Shot.play()
	$/root/Game/GUI/HUD/BulletsNumber.text = str(bullets)
	
func hurt(): die()

func die():
	stop_step_sounds()
	is_dead = true
	set_physics_process(false)
	collision_layer = 0
	$GPUParticles2D.emitting = true
	bullets = 0
	$/root/Game/GUI/HUD/BulletsNumber.text = "0"
	$/root/Game/GUI/DeathScreen.modulate.a = 0
	$/root/Game/GUI/DeathScreen.visible = true
	$Audio/Death.play()

func add_bullets(value: int):
	bullets += value
	$Audio/PickingUp.play()
	$/root/Game/GUI/HUD/BulletsNumber.text = str(bullets)
	
func move(time: float, dont_return_process_after_movement: bool = false):
	set_physics_process(false)
	velocity = Vector2.ZERO
	movement_time = time
	$Sprite.animation = "moving_right" if movement_time > 0 else "moving_left"
	$Sprite.play()
	no_return_of_process = dont_return_process_after_movement
	
