extends Node2D

@onready var ball_spawner: BallSpawner = $BallSpawner
@onready var aiming_arrow: AimingArrow = $AimingArrow
var current_ball: Ball
var shooting_behavior: ShootingBehavior
var active_powerups: Dictionary = {}
@onready var raquette: Raquette = $RaquetteSprite

func _ready() -> void:
	shooting_behavior = BasicShot.new()
	Events.on_power_up_gathered.connect(on_power_up_picked_up)

func _input(event: InputEvent) -> void:
	if not GameState.is_in_game_mode():
		return
	if current_ball and event.is_action_pressed("shoot"):
		aiming_arrow.start_charging_shot()
		raquette.play_prepare_raquette_shoot_anim()
	elif current_ball and event.is_action_released("shoot") and aiming_arrow.is_player_shooting:
		shoot_ball(aiming_arrow.stop_charging_shot())
		raquette.play_raquette_shoot_anim()

func on_power_up_picked_up(power_up: ResPowerUp) -> void:
	if power_up.type in active_powerups:
		active_powerups[power_up.type].start(power_up.duration)
		return
	
	add_powerup(power_up)

func add_powerup(power_up: ResPowerUp) -> void:
	match power_up.type:
		ResPowerUp.PowerUpEnum.TRIPLE_SHOT:
			shooting_behavior = TripleShot.new(shooting_behavior)

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
	shooting_behavior = BasicShot.new()
	
	for powerup_type in active_powerups.keys():
		match powerup_type:
			ResPowerUp.PowerUpEnum.TRIPLE_SHOT:
				shooting_behavior = TripleShot.new(shooting_behavior)

func shoot_ball(data: Dictionary) -> void:
	ball_spawner.start_cooldown()
	apply_powerups_to_ball(current_ball)
	shooting_behavior.shoot(self, get_shoot_direction(data), current_ball)
	current_ball = null

func apply_powerups_to_ball(ball: Ball) -> void:
	for powerup_type in active_powerups.keys():
		match powerup_type:
			ResPowerUp.PowerUpEnum.DRILL_SHOT:
				ball.start_drilling_behavior()

func get_shoot_direction(data: Dictionary) -> Vector2:
	print(data)
	return data.get("shot_direction") * (data.get("shot_strength") * 10)

func set_current_ball(new_ball: Ball):
	current_ball = new_ball

func has_power_up(type: ResPowerUp.PowerUpEnum) -> bool:
	for powerup_type in active_powerups.keys():
		if type == powerup_type:
			return true
	return false
