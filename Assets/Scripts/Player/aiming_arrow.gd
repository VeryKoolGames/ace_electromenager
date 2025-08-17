extends Node2D
class_name AimingArrow

@onready var gpu_particles_2d: GPUParticles2D = $Impact_PerfectShot
@onready var strength_texture_bar: TextureProgressBar = $Mask/StrengthTextureBar
@export var fill_speed := 0.0
var fill_direction = 1
var is_player_shooting := false
var camera: Camera2D

const MIN_ROT = deg_to_rad(-90)
const MAX_ROT = deg_to_rad( 90)

var bar_value: float = 0.0
var shot_direction: Vector2
var scale_down_tween: Tween

func _ready() -> void:
	camera = get_tree().root.get_camera_2d()
	Events.on_game_timer_ended.connect(stop_charge_sound)

func stop_charge_sound() -> void:
	AudioManager.stop_charge_sound()

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
		shot_direction *= -1
		var raw = shot_direction.angle()
		var from_up = raw + deg_to_rad(90)
		rotation = clamp(from_up, MIN_ROT, MAX_ROT)

func handle_strength(delta) -> void:
	if owner.has_power_up(ResPowerUp.PowerUpEnum.FAST_SPAWN_SHOT):
		var tween = create_tween()
		tween.tween_property(strength_texture_bar, "value", strength_texture_bar.max_value, 0.1)
		return
	if strength_texture_bar.value <= strength_texture_bar.min_value:
		fill_direction = 1
	elif strength_texture_bar.value >= strength_texture_bar.max_value:
		fill_direction = -1
	bar_value += (delta * fill_speed) * fill_direction
	strength_texture_bar.value = bar_value

func start_charging_shot() -> void:
	zoom_camera()
	is_player_shooting = true
	AudioManager.play_charge_sound()

func stop_charging_shot() -> Dictionary:
	unzoom_camera()
	var shot_strength = bar_value
	if owner.has_power_up(ResPowerUp.PowerUpEnum.FAST_SPAWN_SHOT):
		shot_strength = strength_texture_bar.max_value
	var is_perfect_shot = shot_strength >= 90
	var ret = {
		"shot_strength": shot_strength,
		"shot_direction": shot_direction.normalized(),
		"is_perfect_shot": is_perfect_shot
	}
	AudioManager.stop_charge_sound()
	if is_perfect_shot:
		animate_shot(true)
		try_to_raise_referee_signal_on_ace()
	else:
		animate_shot(false)
	Events.on_shot_released.emit(bar_value)
	reset_values()
	return ret

func try_to_raise_referee_signal_on_ace() -> void:
	if owner.has_power_up(ResPowerUp.PowerUpEnum.FAST_SPAWN_SHOT):
		return
	var should_raise = randi() % 20 < 5
	if should_raise:
		Events.on_player_aced.emit()

func zoom_camera() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "zoom", camera.zoom + Vector2(0.05, 0.05), 0.1)

func unzoom_camera() -> void:
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2.ONE, 0.1)

func reset_values() -> void:
	is_player_shooting = false
	fill_direction = 1
	bar_value = 0
	var tween = create_tween()
	tween.tween_property(strength_texture_bar, "value", 0, 0.1)

func animate_shot(is_perfect_shot: bool) -> void:
	# If the player scored above 90 we want to reward him with a small animation
	if is_perfect_shot:
		gpu_particles_2d.restart()
	var scale_factor = Vector2(0.4, 0.4) if is_perfect_shot else Vector2(0.1, 0.1)
	scale_down_tween = create_tween()
	var target_scale: Vector2 = scale
	scale_down_tween.tween_property(self, "scale", target_scale + scale_factor, 0.1)
	scale_down_tween.tween_property(self, "scale", target_scale, 0.1)
	scale_down_tween.tween_property(self, "scale", Vector2.ZERO, 0.1)
