extends Node

@onready var timer_label: Label = $Label
@onready var game_timer: Timer = $Timer

var game_states_tresholds: Dictionary = {
	90: false,
	30: false,
}

func _ready() -> void:
	game_timer.timeout.connect(end_game)
	start_timer()

func _process(_delta: float) -> void:
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
