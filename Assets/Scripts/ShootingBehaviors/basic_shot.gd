class_name BasicShot
extends ShootingBehavior

func shoot(_shooter: Node2D, direction: Vector2, ball: Ball) -> void:
	ball.shoot_ball(direction)
