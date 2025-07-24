extends RigidBody2D
class_name Ball

var is_moving := false
var start_velocity

var previous_position: Vector2
var time_since_last_check: float = 0.0
var check_interval: float = 0.7
var movement_threshold: float = 70.0

func _ready() -> void:
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
		if collision_info.get_collider().is_in_group("machines"):
			start_velocity.x *= 1.5
			start_velocity.y *= 1.5
		else:
			start_velocity.x *= 0.8
			start_velocity.y *= 0.8

func check_if_ball_is_stopped() -> void:
	if time_since_last_check >= check_interval:
		time_since_last_check = 0.0
		var distance_moved = global_position.distance_to(previous_position)
		if distance_moved <= movement_threshold:
			Events.on_ball_stopped.emit()
			queue_free()
		else:
			previous_position = global_position

func shoot_ball(direction: Vector2) -> void:
	start_velocity = direction * 4
	is_moving = true
