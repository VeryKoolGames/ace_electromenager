class_name DrillShot
extends ShootingBehavior

var wrapped_behavior: ShootingBehavior

func _init(behavior: ShootingBehavior):
	wrapped_behavior = behavior

func shoot(shooter: Node2D, direction: Vector2, ball: Ball) -> void:
	wrapped_behavior.shoot(shooter, direction, ball)
