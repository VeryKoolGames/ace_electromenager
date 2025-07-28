extends Node2D
class_name BallSpawner

@export var ball_scene: PackedScene
@export var spawn_cooldown := 0
@onready var spawn_point: Node2D = $SpawnPoint
@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	spawn_ball()
	cooldown_timer.wait_time = spawn_cooldown
	cooldown_timer.timeout.connect(on_cooldown_ended)

func spawn_ball() -> void:
	var ball = ball_scene.instantiate() as RigidBody2D
	add_child(ball)
	ball.global_position = spawn_point.global_position
	owner.set_current_ball(ball)

func on_cooldown_ended() -> void:
	spawn_ball()

func start_cooldown() -> void:
	cooldown_timer.start()
