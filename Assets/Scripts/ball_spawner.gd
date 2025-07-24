extends Node2D

@export var ball_scene: PackedScene
@onready var spawn_point: Node2D = $SpawnPoint

func _ready() -> void:
	Events.on_ball_stopped.connect(spawn_ball)
	spawn_ball()

func spawn_ball() -> void:
	var ball = ball_scene.instantiate() as RigidBody2D
	add_child(ball)
	ball.global_position = spawn_point.global_position
	owner.set_current_ball(ball)
