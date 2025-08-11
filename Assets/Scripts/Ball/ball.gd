extends RigidBody2D
class_name Ball

# Components
@onready var scale_on_destroy_component: ScaleOnDestroyComponent = $ScaleOnDestroyComponent
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var sprite: Sprite2D

# Ball properties
var is_moving := false
var is_bouncing := false
var start_velocity: Vector2
var speed_reduction_on_wall_bounce := 0.8
var speed_acceleration_on_machine_bounce = 1.5

# Check if ball is stopped
var previous_position: Vector2
var time_since_last_check: float = 0.0
var check_interval: float = 0.7
var movement_threshold: float = 20.0

# Dynamic scaling properties
@export var base_scale: Vector2 = Vector2.ONE
@export var max_scale_multiplier: float = 1.3
@export var min_scale_multiplier: float = 0.8
@export var scale_speed_threshold: float = 2000.0
@export var scale_lerp_speed: float = 8.0

var target_scale: Vector2

@export var rotation_speed_multiplier: float = 5.0
@export var min_rotation_speed: float = 0.8

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	previous_position = global_position
	Events.on_power_up_expired.connect(remove_power_ups)

func remove_power_ups(type: ResPowerUp.PowerUpEnum) -> void:
	if type == ResPowerUp.PowerUpEnum.REBOUND_SHOT:
		is_bouncing = false

func _process(delta: float) -> void:
	if is_moving:
		time_since_last_check += delta
		check_if_ball_is_stopped()
		start_velocity *= 0.99
		update_scale_based_on_velocity(delta)
		update_rotation_based_on_velocity(delta)
		check_collisions(move_and_collide(start_velocity * delta))

func update_scale_based_on_velocity(delta: float) -> void:
	var current_speed = start_velocity.length()
	var speed_ratio = clamp(current_speed / scale_speed_threshold, 0.0, 1.0)
	var scale_multiplier = lerp(min_scale_multiplier, max_scale_multiplier, speed_ratio)
	target_scale = base_scale * scale_multiplier
	sprite.scale = sprite.scale.lerp(target_scale, scale_lerp_speed * delta)

func update_rotation_based_on_velocity(delta: float) -> void:
	var current_speed = start_velocity.length()
	var rotation_speed = max(current_speed * rotation_speed_multiplier * 0.001, min_rotation_speed)
	sprite.rotation += rotation_speed * delta * randf_range(0.8, 1.2)

func start_bouncing_behavior() -> void:
	is_bouncing = true

func check_collisions(collision_info: KinematicCollision2D) -> void:
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.is_in_group("machines"):
			collider.owner.repair()
			if is_bouncing:
				start_velocity = start_velocity.bounce(collision_info.get_normal())
				start_velocity *= speed_acceleration_on_machine_bounce
			else:
				queue_free()
		else:
			start_velocity = start_velocity.bounce(collision_info.get_normal())
			start_velocity *= speed_reduction_on_wall_bounce
			AudioManager.play_rebound_sound()

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
