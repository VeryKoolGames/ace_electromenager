extends Node2D

var current_ball: Ball
var aiming_direction
var shooting_behavior: IShootingBehavior

func _input(event: InputEvent) -> void:
	if not GameState.is_in_game_mode():
		return
	if current_ball and event.is_action_pressed("shoot"):
		shoot_ball()

func shoot_ball() -> void:
	shooting_behavior.shoot(global_position, get_shoot_direction())
	var mpos = get_global_mouse_position()
	var dir  = (mpos - global_position).normalized()
	# We should build a bar that fills up and that will give us the multiplication value here
	current_ball.shoot_ball(dir * 1000)
	current_ball = null

func get_shoot_direction() -> Vector2:
	var mpos = get_global_mouse_position()
	var dir  = (mpos - global_position).normalized()
	return dir * 1000

func set_current_ball(new_ball: Ball):
	current_ball = new_ball
