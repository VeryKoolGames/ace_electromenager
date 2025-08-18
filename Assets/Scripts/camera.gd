extends CanvasLayer

@export var randomStrenght: float = 30
@export var shakeFade: float = 10.0
var rng = RandomNumberGenerator.new();
var shakeStrenght: float = 0.0
var shake_cooldown := 0.5

func _ready() -> void:
	Events.on_shot_released.connect(apply_shake)

func apply_shake(strength: float):
	if strength >= 80:
		shakeStrenght = 20
	else:
		shakeStrenght = 5

func _process(delta):
	if shakeStrenght > 0:
		shakeStrenght = lerpf(shakeStrenght, 0, shakeFade * delta)
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrenght, shakeStrenght),rng.randf_range(-shakeStrenght, shakeStrenght))
