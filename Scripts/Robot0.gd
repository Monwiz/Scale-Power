extends RigidBody2D


@export var speed = 30.0
@export_range(1,50) var health: int = 3
var is_dead = false
var timer = 0

func _process(delta):
	timer -= delta
	if timer < 0:
		$Field.visible = false
	if is_dead:
		modulate.a -= 8*delta
		if modulate.a <= 0:
			queue_free()
	if modulate.r > 1:
		modulate = Color(modulate.r-16*delta,modulate.g-16*delta,modulate.b-16*delta,modulate.a)
	else: modulate = Color(1,1,1,modulate.a)
	if health <= 0:
		die()

func hurt(damage: int = 1):
	health -= damage
	modulate = Color(4,4,4)

func die():
	is_dead = true
	set_physics_process(false)
	collision_layer = 0

func _on_area_2d_body_entered(body):
	if body != self:
		$Field.visible = true
		timer = 1
		if body.has_method("hurt"):
			body.hurt(100)
