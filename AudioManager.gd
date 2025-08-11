extends Node

@export var shoot_sounds: Array[AudioStreamPlayer2D]
@export var rebound_sounds: Array[AudioStreamPlayer2D]
@export var charge_sound: AudioStreamPlayer2D
@export var whistle_sound: AudioStreamPlayer2D

func play_shoot_sound() -> void:
	shoot_sounds[randi_range(0, shoot_sounds.size() - 1)].play()

func play_charge_sound() -> void:
	charge_sound.play()

func play_rebound_sound() -> void:
	rebound_sounds[randi_range(0, shoot_sounds.size() - 1)].play()

func play_whistle_sound() -> void:
	whistle_sound.play()
