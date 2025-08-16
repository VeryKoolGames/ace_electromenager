extends CanvasLayer

@onready var transi_screen: TextureRect = $Control/TextureRect

enum MainScenesEnum {
	GAME,
	LEADERBOARD,
	START,
	TUTORIAL
}

var scenes_dict := {
	MainScenesEnum.GAME : "res://Assets/Scenes/Main/main.tscn",
	MainScenesEnum.LEADERBOARD : "res://Assets/Scenes/Main/leaderboard.tscn",
	MainScenesEnum.START : "res://Assets/Scenes/Main/start_menu.tscn",
	MainScenesEnum.TUTORIAL : "res://Assets/Scenes/Main/tutorial.tscn",
}

var original_pos: Vector2
var original_rotation: float

func _ready() -> void:
	original_pos = transi_screen.position
	original_rotation = transi_screen.rotation

func play_transition(scene_to_transition_to: MainScenesEnum) -> void:
	AudioManager.play_transition_sound()
	transi_screen.show()
	transi_screen.position = original_pos
	transi_screen.rotation = original_rotation
	var scene = scenes_dict[scene_to_transition_to]
	var target_position = transi_screen.position.x / 2 + get_tree().root.get_visible_rect().size.x / 2
	
	var tween = create_tween()
	tween.set_parallel()
	
	# Position avec easing
	tween.tween_property(
		transi_screen,
		"position:x",
		target_position,
		0.8
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Rotation avec easing
	tween.tween_property(
		transi_screen,
		"rotation",
		deg_to_rad(360),
		0.8
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	_play_out_transition(scene)

func _play_out_transition(scene: String) -> void:
	get_tree().change_scene_to_file(scene)
	await get_tree().create_timer(1.3).timeout
	AudioManager.play_transition_sound()
	transi_screen.rotation = original_rotation
	var tween = create_tween()
	var target_position = get_tree().root.get_viewport().size.x
	tween.set_parallel()
	tween.tween_property(transi_screen, "position:x", target_position, 0.8)
	tween.tween_property(transi_screen, "rotation", deg_to_rad(360), 0.8)
	tween.tween_callback(func(): transi_screen.hide()).set_delay(0.4)
