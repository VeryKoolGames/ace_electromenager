extends Node2D
class_name BallSpawner

@export var ball_scene: PackedScene
@export var spawn_cooldown: ResFloatValue
@export var fast_spawn_cooldown := 0.0
@export var aiming_arrow: Node2D
var aiming_arrow_base_scale: Vector2
@onready var spawn_point: Node2D = $SpawnPoint
@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	aiming_arrow_base_scale = aiming_arrow.scale
	spawn_ball()
	cooldown_timer.wait_time = spawn_cooldown.value
	cooldown_timer.timeout.connect(on_cooldown_ended)
	Events.on_power_up_activated.connect(on_fast_show_power_up_picked_up)
	Events.on_power_up_expired.connect(on_fast_show_power_up_expired)

func spawn_ball() -> void:
	if owner.current_ball:
		return
	scale_raquette()
	var ball = ball_scene.instantiate() as Ball
	call_deferred("add_child", ball)
	ball.global_position = spawn_point.position
	owner.set_current_ball(ball)
	if owner.has_power_up(ResPowerUp.PowerUpEnum.REBOUND_SHOT):
		ball.start_bouncing_behavior()

func on_cooldown_ended() -> void:
	spawn_ball()

func start_cooldown() -> void:
	cooldown_timer.start()

func on_fast_show_power_up_picked_up(power_up: ResPowerUp) -> void:
	if power_up.type == ResPowerUp.PowerUpEnum.FAST_SPAWN_SHOT:
		cooldown_timer.wait_time = fast_spawn_cooldown
		spawn_ball()

func on_fast_show_power_up_expired(type: ResPowerUp.PowerUpEnum) -> void:
	if type == ResPowerUp.PowerUpEnum.FAST_SPAWN_SHOT:
		cooldown_timer.wait_time = spawn_cooldown.value

func scale_raquette() -> void:
	var tween = create_tween()
	tween.tween_property(aiming_arrow, "scale", aiming_arrow_base_scale, 0.1)
