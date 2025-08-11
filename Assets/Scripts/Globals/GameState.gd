extends Node

enum GameStateEnum {
	START,
	GAME,
	END,
	TUTORIAL_STOP,
	TUTORIAL_PLAY,
}

var current_game_state := GameStateEnum.START

func is_in_game_mode() -> bool:
	return current_game_state == GameStateEnum.GAME

func set_game_mode() -> void:
	current_game_state = GameStateEnum.GAME

func set_tutorial_mode() -> void:
	current_game_state = GameStateEnum.TUTORIAL_PLAY
