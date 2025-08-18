extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/Logo/AnimationPlayer

func _ready() -> void:
	await animation_player.animation_finished
	transition_to_start_scene()


func transition_to_start_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.START)
	AudioManager.start_menu_music()
