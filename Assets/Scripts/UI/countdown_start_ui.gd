extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_start_animation() -> void:
	animation_player.play("game_start")
