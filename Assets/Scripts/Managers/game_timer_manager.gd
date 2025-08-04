extends Node

@onready var timer_label: Label = $Label
@onready var game_timer: Timer = $Timer

func _ready() -> void:
	game_timer.timeout.connect(end_game)
	start_timer()

func _process(_delta: float) -> void:
	timer_label.text = time_to_minutes_secs(game_timer.time_left)

func start_timer() -> void:
	game_timer.start()

func time_to_minutes_secs(time : float):
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time) 
	return str(mins) + ":" + str(secs)

func end_game() -> void:
	GameState.current_game_state = GameState.GameStateEnum.END
	Events.on_game_timer_ended.emit()
