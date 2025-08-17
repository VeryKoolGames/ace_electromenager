extends Node

@export var shoot_sounds: Array[AudioStreamPlayer2D]
@export var rebound_sounds: Array[AudioStreamPlayer2D]
@export var charge_sound: AudioStreamPlayer2D
@export var whistle_sound: AudioStreamPlayer2D
@onready var menu_music: AudioStreamPlayer2D = $MainMusics/MenuMusic
@onready var main_music: AudioStreamPlayer2D = $MainMusics/MainMusic
@onready var transition_sound: AudioStreamPlayer2D = $TransitionSound/TransitionSound
@onready var end_menu_music: AudioStreamPlayer2D = $EndMenuMusic/EndMenuMusic
@onready var ref_ace: AudioStreamPlayer2D = $Ref/RefAce
@onready var ref_hurt: AudioStreamPlayer2D = $Ref/RefHurt
@onready var ref_long_talk: AudioStreamPlayer2D = $Ref/RefLongTalk

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
	await get_tree().create_timer(1.5).timeout
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

func play_end_menu_music() -> void:
	end_menu_music.play()

func stop_end_menu_music() -> void:
	end_menu_music.stop()

func play_ref_long_talk() -> void:
	ref_long_talk.play()

func stop_ref_long_talk() -> void:
	ref_long_talk.stop()

func play_ref_hurt() -> void:
	ref_hurt.pitch_scale = randf_range(0.9, 1.1)
	ref_hurt.play()

func play_ref_ace() -> void:
	ref_ace.pitch_scale = randf_range(0.9, 1.1)
	ref_ace.play()
