extends Node

enum GameStateEnum {
	TUTORIAL,
	GAME,
	END
}

var current_game_state := GameStateEnum.GAME

func is_in_game_mode() -> bool:
	return current_game_state == GameStateEnum.GAME
