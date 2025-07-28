extends RigidBody2D
class_name Ball

@onready var scale_on_destroy_component: ScaleOnDestroyComponent = $ScaleOnDestroyComponent

# Ball properties
var is_moving := false
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

func check_collisions(collision_info: KinematicCollision2D) -> void:
	if collision_info:
		start_velocity = start_velocity.bounce(collision_info.get_normal())
		var collider = collision_info.get_collider()
		if collider.is_in_group("machines"):
			collider.owner.repair()
			start_velocity *=  speed_acceleration_on_machine_bounce
		else:
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
