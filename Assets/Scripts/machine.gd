extends Node2D
class_name Machine

@export var repair_particle: GPUParticles2D
@export var sprite: Sprite2D
@export var score_value := 0

func repair() -> void:
	switch_texture_to_white()
	Events.on_player_scored.emit(score_value)

func switch_texture_to_white() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:v", 1, 0.25).from(15)
