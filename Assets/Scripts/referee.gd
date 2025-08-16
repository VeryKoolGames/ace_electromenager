extends Node2D
class_name Referee

@onready var mouth_animation_player: AnimationPlayer = $MouthAnimationPlayer
@onready var body_sprite: Sprite2D = $Sprite2D
@export var talking_positions: Array[Texture2D]
var base_sprite: Texture2D
var latest_texture: String

func _ready() -> void:
	base_sprite = body_sprite.texture

func start_talking() -> void:
	var texture = talking_positions[randi_range(0, talking_positions.size() - 1)] as Texture2D
	while latest_texture == texture.resource_path:
		texture = talking_positions[randi_range(0, talking_positions.size() - 1)] as Texture2D
	latest_texture = texture.resource_name
	body_sprite.texture = texture
	mouth_animation_player.play("talk")

func hide_mouth() -> void:
	await get_tree().create_timer(0.5).timeout
	mouth_animation_player.stop()
	$Bouche.hide()

func stop_talking() -> void:
	await get_tree().create_timer(0.5).timeout
	body_sprite.texture = base_sprite
	mouth_animation_player.stop()
	$Bouche.hide()
