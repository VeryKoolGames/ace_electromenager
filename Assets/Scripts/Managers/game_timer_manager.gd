extends Node

@onready var timer_label: Label = $Label
@onready var game_timer: Timer = $Timer
@export var game_length: ResFloatValue

var game_states_tresholds: Dictionary

func _ready() -> void:
	game_states_tresholds = {
		int(game_length.value / 2): false,
		int(game_length.value / 4): false,
	}
	game_timer.timeout.connect(end_game)
	game_timer.wait_time = game_length.value
	timer_label.text = time_to_minutes_secs(game_length.value)
	Events.on_game_started.connect(on_game_start)

func on_game_start() -> void:
	start_timer()

func _process(_delta: float) -> void:
	if game_timer.is_stopped():
		return
	timer_label.text = time_to_minutes_secs(game_timer.time_left)
	check_game_states_tresholds()

func check_game_states_tresholds() -> void:
	for key in game_states_tresholds.keys():
		if game_timer.time_left <= key and not game_states_tresholds[key]:
			Events.on_game_state_advanced.emit()
			game_states_tresholds[key] = true

func start_timer() -> void:
	game_timer.start()

func time_to_minutes_secs(time : float):
	@warning_ignore("integer_division")
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	if secs < 10:
		secs = "0" + str(secs)
	else:
		secs = str(secs)
	return "0" + str(mins) + ":" + secs

func end_game() -> void:
	GameState.current_game_state = GameState.GameStateEnum.END
	Events.on_game_timer_ended.emit()
