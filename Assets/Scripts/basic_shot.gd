class_name BasicShot
extends ShootingBehavior

func shoot(ball: Ball, direction: Vector2):
	ball.shoot_ball(direction)
