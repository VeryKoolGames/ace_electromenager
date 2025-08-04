extends Node2D

const MIN_ROT = deg_to_rad(-90)
const MAX_ROT = deg_to_rad( 90)

func _process(_delta):
	if not GameState.is_in_game_mode():
		return
	var mpos = get_global_mouse_position()
	var dir  = (mpos - global_position)

	if dir.y < 0:
		var raw = dir.angle()
		var from_up = raw + deg_to_rad(90)
		rotation = clamp(from_up, MIN_ROT, MAX_ROT)
	else:
		rotation = (MIN_ROT if dir.x < 0 else MAX_ROT)
