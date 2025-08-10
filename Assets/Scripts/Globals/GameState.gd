extends Node

enum GameStateEnum {
	START,
	GAME,
	END
}

var current_game_state := GameStateEnum.START

func is_in_game_mode() -> bool:
	return current_game_state == GameStateEnum.GAME

func set_game_mode() -> void:
	current_game_state = GameStateEnum.GAME
