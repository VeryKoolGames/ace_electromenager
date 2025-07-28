extends ColorRect
class_name PowerUpLine

@export var duration_timer: Timer
@export var progress_bar: ProgressBar
@export var sprite_texture: TextureRect
var type: ResPowerUp.PowerUpEnum
var start_duration: float
var sprite: Texture2D

func _ready() -> void:
	duration_timer.timeout.connect(on_timer_ended)
	progress_bar.max_value = start_duration
	duration_timer.wait_time = start_duration
	duration_timer.start()
	sprite_texture.texture = sprite

func init(power_up: ResPowerUp):
	start_duration = power_up.duration
	self.sprite = power_up.sprite
	self.type = power_up.type

func _process(delta: float) -> void:
	if not duration_timer.is_stopped():
		progress_bar.value = duration_timer.time_left

func reset_progress_duration():
	duration_timer.start()

func on_timer_ended() -> void:
	queue_free()
