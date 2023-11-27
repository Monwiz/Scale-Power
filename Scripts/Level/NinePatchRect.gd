extends NinePatchRect

#var up_left_corner: Rect2
#var up_right_corner: Rect2
#var down_left_corner: Rect2
#var down_right_corner: Rect2

var holding: int = 0
var parent_object: Node
func set_parent_object(value: Node): parent_object = value
func get_holding(): return holding
func set_holding(value: int): holding = value
func get_corner_color(corner: int):
	match corner:
		1: return $UpLeft.color
		2: return $UpRight.color
		3: return $DownLeft.color
		4: return $DownRight.color
func set_corner_color(color: Color, corner: int):
	match corner:
		1: $UpLeft.color = color
		2: $UpRight.color = color
		3: $DownLeft.color = color
		4: $DownRight.color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#up_left_corner    = Rect2(global_position.x,			global_position.y, 3, 3)
	#up_right_corner   = Rect2(global_position.x+size.x-3,	global_position.y, 3, 3)
	#down_left_corner  = Rect2(global_position.x,   global_position.y+size.y-3, 3, 3)
	#down_right_corner = Rect2(global_position+size-Vector2(3,3),Vector2(3,3))
	var mpos = round($"../Cursor".global_position)
		
	if not holding:
		if get_parent().get_global_rect().has_point(mpos):
			#if up_left_corner.has_point(mpos): holding = 1
			#elif up_right_corner.has_point(mpos): holding = 2
			#elif down_left_corner.has_point(mpos): holding = 3
			#elif down_right_corner.has_point(mpos): holding = 4
			if $UpLeft.get_global_rect().has_point(mpos):
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					holding = 1
					$UpLeft.color = Color.ORANGE
				else:
					$UpLeft.color = Color.YELLOW
			elif $UpRight.get_global_rect().has_point(mpos):
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					holding = 2
					$UpRight.color = Color.ORANGE
				else:
					$UpRight.color = Color.YELLOW
			elif $DownLeft.get_global_rect().has_point(mpos):
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					holding = 3
					$DownLeft.color = Color.ORANGE
				else:
					$DownLeft.color = Color.YELLOW
			elif $DownRight.get_global_rect().has_point(mpos):
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					holding = 4
					$DownRight.color = Color.ORANGE
				else:
					$DownRight.color = Color.YELLOW
			else:
				if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					holding = -1
				$UpLeft.color = Color.WHITE
				$UpRight.color = Color.WHITE
				$DownLeft.color = Color.WHITE
				$DownRight.color = Color.WHITE
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): holding = -1
	else:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			match holding:
				1: $UpLeft.color = Color.WHITE
				2: $UpRight.color = Color.WHITE
				3: $DownLeft.color = Color.WHITE
				4: $DownRight.color = Color.WHITE
			holding = 0
	var min_x = parent_object.get_minimal_position_x()
	var min_y = parent_object.get_minimal_position_y()
	var max_x = parent_object.get_maximal_position_x()
	var max_y = parent_object.get_maximal_position_y()
	var upper_left = parent_object.get_upper_left_corner()
	var upper_right = parent_object.get_upper_right_corner()
	var bottom_left = parent_object.get_bottom_left_corner()
	var bottom_right = parent_object.get_bottom_right_corner()
	match holding:
		1:
			if mpos.x < upper_left.x and mpos.y < upper_left.y:
				size.x -= upper_left.x-global_position.x
				global_position.x = upper_left.x
				size.y -= upper_left.y-global_position.y
				global_position.y = upper_left.y
			elif mpos.x < bottom_left.x and mpos.y > bottom_left.y-1:
				size.x -= bottom_left.x-global_position.x
				global_position.x = bottom_left.x
				size.y += bottom_left.y-global_position.y-1
				global_position.y = bottom_left.y-1
			elif mpos.x > upper_right.x-1 and mpos.y < upper_right.y:
				size.x += upper_right.x-global_position.x-1
				global_position.x = upper_right.x-1
				size.y -= upper_right.y-global_position.y
				global_position.y = upper_right.y
			elif mpos.x > bottom_right.x-1 and mpos.y > bottom_right.y-1:
				size.x += bottom_right.x-global_position.x-1
				global_position.x = bottom_right.x-1
				size.y += bottom_right.y-global_position.y-1
				global_position.y = bottom_right.y-1
			else:
				if mpos.x < min_x:
					size.x -= min_x-global_position.x
					global_position.x = min_x
				elif mpos.x > max_x-1:
					size.x += max_x-global_position.x-1
					global_position.x = max_x-1
				else: size.x += global_position.x - mpos.x; global_position.x = mpos.x
				if mpos.y < min_y:
					size.y -= min_y-global_position.y
					global_position.y = min_y
				elif mpos.y > max_y-1:
					size.y += max_y-global_position.y-1
					global_position.y = max_y-1
				else: size.y += global_position.y - mpos.y; global_position.y = mpos.y
		2:
			if mpos.x < upper_left.x+1 and mpos.y < upper_left.y:
				size.x = upper_left.x + 1 - global_position.x
				size.y -= upper_left.y-global_position.y
				global_position.y = upper_left.y
			elif mpos.x < bottom_left.x+1 and mpos.y > bottom_left.y-1:
				size.x = bottom_left.x + 1 - global_position.x
				size.y += bottom_left.y-1-global_position.y
				global_position.y = bottom_left.y-1
			elif mpos.x > upper_right.x and mpos.y < upper_right.y:
				size.x = upper_right.x - global_position.x
				size.y -= upper_right.y-global_position.y
				global_position.y = upper_right.y
			elif mpos.x > bottom_right.x and mpos.y > bottom_right.y-1:
				size.x = bottom_right.x - global_position.x
				size.y += bottom_right.y-1-global_position.y
				global_position.y = bottom_right.y
			else:
				if mpos.x < min_x+1:
					size.x = min_x+1 - global_position.x
				elif mpos.x > max_x:
					size.x = max_x - global_position.x
				else: size.x = mpos.x - global_position.x
				if mpos.y < min_y:
					size.y -= min_y-global_position.y
					global_position.y = min_y
				elif mpos.y > max_y-1:
					size.y += max_y-1-global_position.y
					global_position.y = max_y-1
				else: size.y += global_position.y - mpos.y; global_position.y = mpos.y
		3:
			if mpos.x < upper_left.x and mpos.y < upper_left.y:
				size.x -= upper_left.x-global_position.x
				global_position.x = upper_left.x
				size.y = upper_left.y - global_position.y
			elif mpos.x < bottom_left.x and mpos.y > bottom_left.y:
				size.x -= bottom_left.x-global_position.x
				global_position.x = bottom_left.x
				size.y = bottom_left.y - global_position.y
			elif mpos.x > upper_right.x and mpos.y < upper_right.y:
				size.x += upper_right.x-global_position.x
				global_position.x = upper_right.x
				size.y = upper_right.y - global_position.y
			elif mpos.x > bottom_right.x and mpos.y > bottom_right.y:
				size.x += bottom_right.x-global_position.x
				global_position.x = bottom_right.x
				size.y = bottom_right.y - global_position.y
			else:
				if mpos.x < min_x:
					size.x -= min_x-global_position.x
					global_position.x = min_x
				elif mpos.x > max_x:
					size.x += max_x-global_position.x
					global_position.x = max_x
				else: size.x += global_position.x - mpos.x; global_position.x = mpos.x
				if mpos.y < min_y:
					size.y = min_y - global_position.y
				elif mpos.y > max_y:
					size.y = max_y - global_position.y
				else: size.y = mpos.y - global_position.y
		4:
			if mpos.x < upper_left.x and mpos.y < upper_left.y:
				size.x = upper_left.x - global_position.x
				size.y = upper_left.y - global_position.y
			elif mpos.x < bottom_left.x and mpos.y > bottom_left.y:
				size.x = bottom_left.x - global_position.x
				size.y = bottom_left.y - global_position.y
			elif mpos.x > upper_right.x and mpos.y < upper_right.y:
				size.x = upper_right.x - global_position.x
				size.y = upper_right.y - global_position.y
			elif mpos.x > bottom_right.x and mpos.y > bottom_right.y:
				size.x = bottom_right.x - global_position.x
				size.y = bottom_right.y - global_position.y
			else:
				if mpos.x < min_x:
					size.x = min_x - global_position.x
				elif mpos.x > max_x:
					size.x = max_x - global_position.x
				else: size.x = mpos.x - global_position.x
				if mpos.y < min_y:
					size.y = min_y - global_position.y
				elif mpos.y > max_y:
					size.y = max_y - global_position.y
				else: size.y = mpos.y - global_position.y
#	if holding not in [0,-1]:
#		if mpos.x < get_parent().global_position.x:
#			size.x -= get_parent().global_position.x - mpos.x
#			position.x += get_parent().global_position.x - mpos.x
#		elif mpos.x > get_parent().global_position.x + get_parent().size.x:
#			size.x -= mpos.x - get_parent().global_position.x - get_parent().size.x
#		if mpos.y < get_parent().global_position.y:
#			size.y -= get_parent().global_position.y - mpos.y
#			position.y += get_parent().global_position.y - mpos.y
#		elif mpos.y > get_parent().global_position.y + get_parent().size.y:
#			size.y -= mpos.y - get_parent().global_position.y - get_parent().size.y
