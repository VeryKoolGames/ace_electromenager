extends Node2D
class_name AimingArrow

@onready var strength_texture_bar: TextureProgressBar = $Mask/StrengthTextureBar
@export var fill_speed := 0.0
var fill_direction = 1
var is_player_shooting := false

const MIN_ROT = deg_to_rad(-90)
const MAX_ROT = deg_to_rad( 90)

var bar_value: float = 0.0
var shot_direction: Vector2

func _process(delta):
	if not GameState.is_in_game_mode():
		return
	rotate_arrow()
	if not is_player_shooting:
		return
	handle_strength(delta)

func rotate_arrow() -> void:
	var mpos = get_global_mouse_position()
	shot_direction  = (mpos - global_position)

	if shot_direction.y < 0:
		var raw = shot_direction.angle()
		var from_up = raw + deg_to_rad(90)
		rotation = clamp(from_up, MIN_ROT, MAX_ROT)
	else:
		rotation = (MIN_ROT if shot_direction.x < 0 else MAX_ROT)

func handle_strength(delta) -> void:
	if strength_texture_bar.value <= strength_texture_bar.min_value:
		fill_direction = 1
	elif strength_texture_bar.value >= strength_texture_bar.max_value:
		fill_direction = -1
	bar_value += (delta * fill_speed) * fill_direction
	strength_texture_bar.value = bar_value

func start_charging_shot() -> void:
	is_player_shooting = true

func stop_charging_shot() -> Dictionary:
	var ret = {
		"shot_strength": bar_value,
		"shot_direction": shot_direction.normalized()
	}
	reset_values()
	return ret

func reset_values() -> void:
	is_player_shooting = false
	fill_direction = 1
	bar_value = 0
	var tween = create_tween()
	tween.tween_property(strength_texture_bar, "value", 0, 0.1)
