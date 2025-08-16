extends Node

@export var shoot_sounds: Array[AudioStreamPlayer2D]
@export var rebound_sounds: Array[AudioStreamPlayer2D]
@export var charge_sound: AudioStreamPlayer2D
@export var whistle_sound: AudioStreamPlayer2D
@onready var menu_music: AudioStreamPlayer2D = $MainMusics/MenuMusic
@onready var main_music: AudioStreamPlayer2D = $MainMusics/MainMusic
@onready var transition_sound: AudioStreamPlayer2D = $TransitionSound/TransitionSound

var is_muted := false

func play_shoot_sound() -> void:
	shoot_sounds[randi_range(0, shoot_sounds.size() - 1)].play()

func play_charge_sound() -> void:
	charge_sound.play()

func stop_charge_sound() -> void:
	charge_sound.stop()

func play_rebound_sound() -> void:
	rebound_sounds[randi_range(0, shoot_sounds.size() - 1)].play()

func play_whistle_sound() -> void:
	whistle_sound.play()

func mute_all_sounds() -> void:
	is_muted = not is_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), is_muted)

func transition_to_game_music() -> void:
	var out_tween = create_tween()
	out_tween.tween_property(menu_music, "volume_db", -80, 2)
	out_tween.tween_callback(func(): menu_music.stop())
	await out_tween.finished
	main_music.play()

func transition_to_menu_music() -> void:
	if main_music.playing:
		var out_tween = create_tween()
		out_tween.tween_property(main_music, "volume_db", -80, 1.5)
		out_tween.tween_callback(func(): main_music.stop())
		await out_tween.finished
	else:
		await get_tree().create_timer(1.5).timeout
	menu_music.volume_db = 0
	menu_music.play()

func play_transition_sound() -> void:
	transition_sound.play()
