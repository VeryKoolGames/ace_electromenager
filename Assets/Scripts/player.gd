extends Node2D

var current_ball: Ball
var shooting_behavior: ShootingBehavior
var active_powerups: Dictionary = {}  # PowerUpEnum -> Timer

func _ready() -> void:
	shooting_behavior = BasicShot.new()
	Events.on_power_up_gathered.connect(on_power_up_picked_up)

func _input(event: InputEvent) -> void:
	if not GameState.is_in_game_mode():
		return
	if current_ball and event.is_action_pressed("shoot"):
		shoot_ball()

func on_power_up_picked_up(power_up: ResPowerUp) -> void:
	if power_up.type in active_powerups:
		active_powerups[power_up.type].start(power_up.duration)
		return
	
	add_powerup(power_up)

func add_powerup(power_up: ResPowerUp) -> void:
	match power_up.type:
		ResPowerUp.PowerUpEnum.TRIPLE_SHOT:
			shooting_behavior = TripleShot.new(shooting_behavior)
#ResPowerUp.PowerUpEnum.DRILL_SHOT:
#shooting_behavior = DrillShot.new(shooting_behavior)
	
	var timer = Timer.new()
	timer.wait_time = power_up.duration
	timer.one_shot = true
	timer.timeout.connect(func(): remove_powerup(power_up.type))
	add_child(timer)
	timer.start()

	active_powerups[power_up.type] = timer
	
	Events.on_power_up_activated.emit(power_up)

func remove_powerup(type: ResPowerUp.PowerUpEnum) -> void:
	if type not in active_powerups:
		return
	
	var timer = active_powerups[type]
	timer.queue_free()
	active_powerups.erase(type)
	
	rebuild_shooting_behavior()
	
	Events.on_power_up_expired.emit(type)

func rebuild_shooting_behavior() -> void:
	# Start fresh with basic shot
	shooting_behavior = BasicShot.new()
	
	# Reapply all active power-ups
	for powerup_type in active_powerups.keys():
		match powerup_type:
			ResPowerUp.PowerUpEnum.TRIPLE_SHOT:
				shooting_behavior = TripleShot.new(shooting_behavior)
#ResPowerUp.PowerUpEnum.DRILL_SHOT:
#shooting_behavior = DrillShot.new(shooting_behavior)

func shoot_ball() -> void:
	shooting_behavior.shoot(self, get_shoot_direction(), current_ball)
	current_ball = null

func get_shoot_direction() -> Vector2:
	var mpos = get_global_mouse_position()
	var dir = (mpos - global_position).normalized()
	return dir * 1000

func set_current_ball(new_ball: Ball):
	current_ball = new_ball
