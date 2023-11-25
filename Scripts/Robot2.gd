extends RigidBody2D


@export var speed = 30.0
@export_range(1,50) var health: int = 3
var is_dead = false
var timer = 0

func _process(delta):
	timer -= delta
	if $RayCast2D.is_colliding() and $RayCast2D.get_collider().get_name() == "Player" and timer < 0:
		shoot()
	if is_dead:
		modulate.a -= 8*delta
		if modulate.a <= 0:
			queue_free()
	if modulate.r > 1:
		modulate = Color(modulate.r-16*delta,modulate.g-16*delta,modulate.b-16*delta,modulate.a)
	else: modulate = Color(1,1,1,modulate.a)
	if health <= 0:
		die()

func shoot():
	timer = 0.5
	var bullet = $Bullet.duplicate()
	var looking_right = $Sprite2D.scale.x > 1
	bullet.init(self, looking_right, 500*scale.x)
	bullet.global_position = Vector2($Bullet.global_position.x, $Bullet.global_position.y)
	get_parent().add_child(bullet)

func hurt():
	health -= 1
	modulate = Color(4,4,4)

func die():
	is_dead = true
	set_physics_process(false)
	collision_layer = 0
