extends Node2D

@export var sprite: Sprite2D
@export var score_value := 0
@onready var static_body = $StaticBody2D
@onready var smoke_particles: Node2D = $SmokeParticles

func _enter_tree() -> void:
	var target_scale = scale
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", target_scale + Vector2(0.3, 0.3), 0.5)
	tween.tween_property(self, "scale", target_scale, 0.05)

func repair() -> void:
	static_body.collision_layer = 4
	static_body.collision_mask = 4

	switch_texture_to_white()
	scale_up_and_down()
	Events.on_player_scored.emit(score_value)
	Events.on_tutorial_progressed.emit()

func switch_texture_to_white() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "material:shader_parameter/white_progress", 0, 0.5).from(1)

func scale_up_and_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", scale + Vector2(0.3, 0.3), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_delay(0.2)
	tween.tween_callback(func(): self.queue_free())
