extends RigidBody2D
class_name Ball

# Components
@onready var scale_on_destroy_component: ScaleOnDestroyComponent = $ScaleOnDestroyComponent

@export var sprite: Sprite2D

# Ball properties
var is_moving := false
var is_drilling := false
var start_velocity: Vector2
var speed_reduction_on_wall_bounce := 0.8
var speed_acceleration_on_machine_bounce = 1.5

# Check if ball is stopped
var previous_position: Vector2
var time_since_last_check: float = 0.0
var check_interval: float = 0.7
var movement_threshold: float = 20.0

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	previous_position = global_position

func _process(delta: float) -> void:
	if is_moving:
		time_since_last_check += delta
		check_if_ball_is_stopped()
		start_velocity *= 0.99
		check_collisions(move_and_collide(start_velocity * delta))

func start_drilling_behavior() -> void:
	is_drilling = true
	sprite.modulate.a = 0.85

func check_collisions(collision_info: KinematicCollision2D) -> void:
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.is_in_group("machines"):
			collider.owner.repair()
			if is_drilling:
				return
			start_velocity = start_velocity.bounce(collision_info.get_normal())
			start_velocity *= speed_acceleration_on_machine_bounce
		else:
			start_velocity = start_velocity.bounce(collision_info.get_normal())
			start_velocity *= speed_reduction_on_wall_bounce

func check_if_ball_is_stopped() -> void:
	if time_since_last_check >= check_interval:
		time_since_last_check = 0.0
		var distance_moved = global_position.distance_to(previous_position)
		if distance_moved <= movement_threshold:
			scale_on_destroy_component.destroy()
		else:
			previous_position = global_position

func shoot_ball(velocity: Vector2) -> void:
	start_velocity = velocity * 4
	is_moving = true
