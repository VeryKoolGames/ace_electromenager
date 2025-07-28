class_name TripleShot
extends ShootingBehavior

var wrapped_behavior: ShootingBehavior

func _init(behavior: ShootingBehavior):
	wrapped_behavior = behavior

func shoot(shooter: Node2D, direction: Vector2, ball: Ball) -> void:
	wrapped_behavior.shoot(shooter, direction, ball)
	
	var angle_offset = PI / 12
	var left_dir = direction.rotated(-angle_offset)
	var right_dir = direction.rotated(angle_offset)
	
	var left_ball = ball.duplicate()
	var right_ball = ball.duplicate()
	left_ball.global_position = ball.global_position
	right_ball.global_position = ball.global_position
	
	shooter.apply_powerups_to_ball(left_ball)
	shooter.apply_powerups_to_ball(right_ball)
	
	shooter.get_parent().add_child(left_ball)
	shooter.get_parent().add_child(right_ball)
	
	left_ball.shoot_ball(left_dir)
	right_ball.shoot_ball(right_dir)
