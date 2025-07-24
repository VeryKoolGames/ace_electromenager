extends Node2D

var current_ball: Ball
var aiming_direction

func _input(event: InputEvent) -> void:
	if current_ball and event.is_action_pressed("shoot"):
		shoot_ball()

func shoot_ball() -> void:
	var mpos = get_global_mouse_position()
	var dir  = (mpos - global_position)
	current_ball.shoot_ball(dir)
	current_ball = null

func set_current_ball(new_ball: Ball):
	current_ball = new_ball
