extends RigidBody2D


var rects: Array
var active_rect_id: int = 0
@export var size: Vector2

func get_minimal_position_x():
	var minimal_x: int = -9999
	for rect in rects:
		var current_zone = rect.get_parent()
		if current_zone.get_global_rect().intersects(rect.get_global_rect()):
			while not current_zone.get_meta("left_border"):
				for zone in $/root/Game/Area2D/SizableZones.get_children():
					if zone.get_global_rect().has_point(Vector2(current_zone.global_position.x-1,current_zone.global_position.y)):
						current_zone = zone
						break
			minimal_x = max(minimal_x, current_zone.global_position.x)
	return minimal_x
func get_minimal_position_y():
	var minimal_y: int = -9999
	for rect in rects:
		var current_zone = rect.get_parent()
		if current_zone.get_global_rect().intersects(rect.get_global_rect()):
			while not current_zone.get_meta("upper_border"):
				for zone in $/root/Game/Area2D/SizableZones.get_children():
					if zone.get_global_rect().has_point(Vector2(current_zone.global_position.x,current_zone.global_position.y-1)):
						current_zone = zone
						break
			minimal_y = max(minimal_y, current_zone.global_position.y)
	return minimal_y
func get_maximal_position_x():
	var maximal_x: int = 9999
	for rect in rects:
		var current_zone = rect.get_parent()
		if current_zone.get_global_rect().intersects(rect.get_global_rect()):
			while not current_zone.get_meta("right_border"):
				for zone in $/root/Game/Area2D/SizableZones.get_children():
					if zone.get_global_rect().has_point(Vector2(current_zone.global_position.x+current_zone.size.x,current_zone.global_position.y)):
						current_zone = zone
						break
			maximal_x = min(maximal_x, current_zone.global_position.x+current_zone.size.x-1)
	return maximal_x
func get_maximal_position_y():
	var maximal_y: int = 9999
	for rect in rects:
		var current_zone = rect.get_parent()
		if current_zone.get_global_rect().intersects(rect.get_global_rect()):
			while not current_zone.get_meta("bottom_border"):
				for zone in $/root/Game/Area2D/SizableZones.get_children():
					if zone.get_global_rect().has_point(Vector2(current_zone.global_position.x,current_zone.global_position.y+current_zone.size.y)):
						current_zone = zone
						break
			maximal_y = min(maximal_y, current_zone.global_position.y+current_zone.size.y-1)
	return maximal_y

func get_upper_left_corner():
	var minimal_x: int = -9999
	var minimal_y: int = -9999
	for zone in $/root/Game/Area2D/SizableZones.get_children():
		if zone.get_global_rect().has_point(get_global_position()-size/2):
			if zone.get_meta("upper_left_corner"):
				minimal_x = zone.global_position.x
				minimal_y = zone.global_position.y
			break
	return Vector2(minimal_x,minimal_y)
func get_upper_right_corner():
	var maximal_x: int = 9999
	var minimal_y: int = -9999
	for zone in $/root/Game/Area2D/SizableZones.get_children():
		if zone.get_global_rect().has_point(Vector2(get_global_position().x+size.x/2-1,get_global_position().y-size.y/2)):
			if zone.get_meta("upper_right_corner"):
				maximal_x = zone.global_position.x+zone.size.x-1
				minimal_y = zone.global_position.y
			break
	return Vector2(maximal_x,minimal_y)
func get_bottom_left_corner():
	var minimal_x: int = -9999
	var maximal_y: int = 9999
	for zone in $/root/Game/Area2D/SizableZones.get_children():
		if zone.get_global_rect().has_point(Vector2(get_global_position().x-size.x/2,get_global_position().y+size.y/2-1)):
			if zone.get_meta("bottom_left_corner"):
				minimal_x = zone.global_position.x
				maximal_y = zone.global_position.y+zone.size.y-1
			break
	return Vector2(minimal_x,maximal_y)
func get_bottom_right_corner():
	var maximal_x: int = 9999
	var maximal_y: int = 9999
	for zone in $/root/Game/Area2D/SizableZones.get_children():
		if zone.get_global_rect().has_point(get_global_position()+size/2-Vector2.ONE):
			if zone.get_meta("bottom_right_corner"):
				maximal_x = zone.global_position.x+zone.size.x-1
				maximal_y = zone.global_position.y+zone.size.y-1
			break
	return Vector2(maximal_x,maximal_y)
# Called when the node enters the scene tree for the first time.
func _ready():
	var rectBase = $/root/Game/Area2D/NinePatchRect.duplicate()
	rectBase.size = round(size)+Vector2(1,1)
	rectBase.visible = true
	rectBase.process_mode = Node.PROCESS_MODE_INHERIT
	#rectBase.z_index = 1
	for zone in $/root/Game/Area2D/SizableZones.get_children():
		var rect = rectBase.duplicate()
		rect.set_parent_object(self)
		rect.global_position = round(global_position - rect.size/2)
		zone.add_child(rect)
		rects.append(rect)
	rectBase.free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var active_rect = rects[active_rect_id]
	var holding = active_rect.get_holding()
	var pos
	if holding in [0,-1]:
		for i in range(rects.size()):
			if i == active_rect_id: continue
			if rects[i].get_holding() not in [0,-1]:
				holding = rects[i].get_holding()
				active_rect.set_holding(0)
				active_rect_id = i
				active_rect = rects[active_rect_id]
				break
	match holding:
		1: pos = active_rect.global_position#global_position-size/2
		2: pos = Vector2(active_rect.global_position.x + active_rect.size.x - 1, active_rect.global_position.y)#Vector2(global_position.x+size.x/2-1, global_position.y-size.y/2)
		3: pos = Vector2(global_position.x-size.x/2, active_rect.global_position.y + active_rect.size.y - 1)#Vector2(global_position.x-size.x/2, global_position.y+size.y/2-1)
		4: pos = active_rect.global_position + active_rect.size - Vector2.ONE#global_position+size/2-Vector2.ONE
	if pos and not active_rect.get_parent().get_global_rect().has_point(pos):
		for i in range(rects.size()):
			if i == active_rect_id: continue
			if rects[i].get_parent().get_global_rect().has_point(pos):
				rects[i].set_holding(holding)
				active_rect.set_holding(-1)
				active_rect_id = i
				active_rect = rects[i]
				break
	if holding not in [0,-1]:
		if active_rect.size - Vector2(1,1) != round(size):
			size = active_rect.size - Vector2(1,1)
			mass = max(size.x*size.y/51200, 0.01)
			$Sprite2D.scale = size/16
			$Collision.scale = size/16
			$Collision.global_position = active_rect.global_position + active_rect.size/2
			global_position = active_rect.global_position + active_rect.size/2
	
	if size.x == 1 or size.y == 1:
		for rect in rects: rect.queue_free()
		queue_free()
	else:
		if holding not in [0,-1]:
			for rect in rects:
				rect.set_corner_color(active_rect.get_corner_color(holding), holding)
			freeze = true
		else: freeze = false
		for rect in rects:
			rect.size = round(size) + Vector2(1,1)
			rect.global_position = round(global_position - rect.size/2)
		linear_velocity.x = clamp(linear_velocity.x, -1, 1) #dirty hack, I'm not able to fix the problem behind it

