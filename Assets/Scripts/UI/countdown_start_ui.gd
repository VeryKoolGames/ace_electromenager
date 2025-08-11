extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_start_animation() -> void:
	animation_player.play("game_start")
	# Really bad but playing the sound with a magic number here as i cannot animate it
	await get_tree().create_timer(1).timeout
	AudioManager.play_whistle_sound()
