extends CanvasLayer

@export var randomStrenght: float = 30
@export var shakeFade: float = 10.0
var rng = RandomNumberGenerator.new();
var shakeStrenght: float = 0.0
var shake_cooldown := 0.5
@export var normal_shot_shake_strength := 5
@export var perfect_shot_shake_strength := 20

func _ready() -> void:
	Events.on_shot_released.connect(apply_shake)
	Events.on_game_state_advanced.connect(on_game_progressed)

func apply_shake(strength: float):
	if strength >= 80:
		shakeStrenght = perfect_shot_shake_strength
	else:
		shakeStrenght = normal_shot_shake_strength

func on_game_progressed(state: int):
	if state == 0:
		return
	perfect_shot_shake_strength += 15

func _process(delta):
	if shakeStrenght > 0:
		shakeStrenght = lerpf(shakeStrenght, 0, shakeFade * delta)
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrenght, shakeStrenght),rng.randf_range(-shakeStrenght, shakeStrenght))
