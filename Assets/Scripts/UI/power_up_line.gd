extends ColorRect
class_name PowerUpLine

@export var duration_timer: Timer
@export var progress_bar: ProgressBar
@export var sprite_texture: TextureRect
@export var power_up_label: Label
var type: ResPowerUp.PowerUpEnum
var start_duration: float
var sprite: Texture2D
var power_up_name: String
var is_active := true
@onready var scale_on_destroy_component: ScaleOnDestroyComponent = $ScaleOnDestroyComponent

func _ready() -> void:
	duration_timer.timeout.connect(on_timer_ended)
	progress_bar.max_value = start_duration
	duration_timer.wait_time = start_duration
	power_up_label.text = power_up_name
	duration_timer.start()
	sprite_texture.texture = sprite

func init(power_up: ResPowerUp):
	start_duration = power_up.duration
	sprite = power_up.sprite
	type = power_up.type
	power_up_name = power_up.name

func _process(_delta: float) -> void:
	if not duration_timer.is_stopped():
		progress_bar.value = duration_timer.time_left

func reset_progress_duration():
	duration_timer.start()

func on_timer_ended() -> void:
	is_active = false
	scale_on_destroy_component.destroy()
