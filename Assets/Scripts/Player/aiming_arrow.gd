extends Node2D

const MIN_ROT = deg_to_rad(-90)
const MAX_ROT = deg_to_rad( 90)

var shot_strength: float = 0.0
var shot_direction: Vector2

func _process(_delta):
	if not GameState.is_in_game_mode():
		return
	var mpos = get_global_mouse_position()
	shot_direction  = (mpos - global_position)

	if shot_direction.y < 0:
		var raw = shot_direction.angle()
		var from_up = raw + deg_to_rad(90)
		rotation = clamp(from_up, MIN_ROT, MAX_ROT)
	else:
		rotation = (MIN_ROT if shot_direction.x < 0 else MAX_ROT)

func start_charging_shot() -> void:
	pass

func stop_charging_shot() -> Dictionary:
	return {
		"shot_strength": shot_strength,
		"shot_direction": shot_direction.normalized()
	}
