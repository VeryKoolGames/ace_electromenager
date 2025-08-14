extends Node

enum GameStateEnum {
	START,
	GAME,
	END,
	TUTORIAL_PLAY,
	PAUSE
}

var current_game_state := GameStateEnum.START

func is_in_game_mode() -> bool:
	return current_game_state == GameStateEnum.GAME

func is_in_tutorial_mode() -> bool:
	return current_game_state == GameStateEnum.TUTORIAL_PLAY

func set_game_mode() -> void:
	current_game_state = GameStateEnum.GAME

func set_tutorial_mode() -> void:
	current_game_state = GameStateEnum.TUTORIAL_PLAY

func set_game_mode_after_pause() -> void:
	await get_tree().create_timer(0.2).timeout
	set_game_mode()

func set_pause_mode() -> void:
	current_game_state = GameStateEnum.PAUSE
