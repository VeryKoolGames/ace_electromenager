extends CanvasLayer

@onready var back_button: TextureButton = $LeftContainer/MarginBackButton/BackButton

func _ready() -> void:
	back_button.pressed.connect(transition_to_main_scene)

func transition_to_main_scene() -> void:
	TransitionManager.play_transition(TransitionManager.MainScenesEnum.START)
