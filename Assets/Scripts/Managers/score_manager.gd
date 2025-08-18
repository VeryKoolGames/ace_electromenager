extends Node
class_name ScoreManager

var current_score := 0
var score_buffer := 0
@export var treshold_to_congratulate_player := 100
@onready var score_label: Label = $ScoreLabel
@export var score_ui_component_scene: PackedScene
@onready var score_buffer_label: Label = $MarginContainer/ScoreBufferLabel
@onready var multiplier_label: Label = $HBoxContainer2/HBoxContainer/Control/MultiplierLabel
@export var multiplier_enabled_color: Color
@export var multiplier_base_color: Color
@export var fire_textures: Array[TextureRect]

var current_number_of_perfect_shot := 0

var buffer_timer: Timer
var is_transferring_score := false
var multiplier := 1.0
var score_buffer_tween: Tween
var score_label_original_position: Vector2
var is_tutorial := false
var base_shader_speed := 0.0

func _ready() -> void:
	var shader_material = fire_textures[0].material as ShaderMaterial
	base_shader_speed = shader_material.get_shader_parameter("Speed").y
	Events.on_player_scored.connect(on_score_received)
	Events.on_machine_repaired.connect(spawn_score_component)
	buffer_timer = Timer.new()
	buffer_timer.wait_time = 1.0
	buffer_timer.one_shot = true
	buffer_timer.timeout.connect(_transfer_buffer_to_score)
	add_child(buffer_timer)
	score_label.text = str(current_score)
	score_buffer_label.text = ""
	score_buffer_label.modulate.a = 0
	await get_tree().process_frame
	score_label_original_position = score_buffer_label.global_position
	if not owner is Tutorial:
		Events.on_perfect_shot.connect(on_perfect_shot)
		Events.on_normal_shot.connect(on_normal_shot)
	else:
		owner.on_fourth_part_started.connect(connect_signals_on_tutorial_mode)

func connect_signals_on_tutorial_mode() -> void:
	Events.on_perfect_shot.connect(on_perfect_shot)
	Events.on_normal_shot.connect(on_normal_shot)
	is_tutorial = true

func on_perfect_shot() -> void:
	if current_number_of_perfect_shot + 1 > fire_textures.size():
		return
	if is_tutorial:
		Events.on_tutorial_progressed.emit()
		is_tutorial = false
	AudioManager.play_fire_sound(current_number_of_perfect_shot * 0.1)
	current_number_of_perfect_shot += 1
	await display_fire()
	scale_up_fires_on_perfect_shot()
	modify_label()

func modify_label() -> void:
	multiplier_label.text = "x" + str(current_number_of_perfect_shot)
	if current_number_of_perfect_shot == 0:
		multiplier_label.modulate = multiplier_base_color
	else:
		multiplier_label.modulate = multiplier_enabled_color

func scale_up_fires_on_perfect_shot() -> void:
	var target_increase = current_number_of_perfect_shot * 0.2
	var target_scale = Vector2(1 + target_increase, 1 + target_increase)
	for fire in fire_textures:
		if fire.visible:
			fire.scale = target_scale
			if current_number_of_perfect_shot == fire_textures.size():
				Events.on_max_fire_reached.emit()
				var target = Vector2(0.0, 1)
				fire.material.set_shader_parameter("Speed", target)
	multiplier_label.scale = target_scale

func scale_down_fires_on_perfect_shot() -> void:
	var target_decrease = current_number_of_perfect_shot * 0.2
	for fire in fire_textures:
		if fire.visible:
			fire.scale -= Vector2(0.2, 0.2)
			var target = Vector2(0.0, base_shader_speed)
			fire.material.set_shader_parameter("Speed", target)
	multiplier_label.scale -= Vector2(0.2, 0.2)

func on_normal_shot() -> void:
	if current_number_of_perfect_shot - 1 < 0:
		return
	AudioManager.reset_fire_sound_pitch(current_number_of_perfect_shot * 0.1)
	scale_down_fires_on_perfect_shot()
	current_number_of_perfect_shot -= 1
	hide_fire()
	modify_label()

func hide_fire() -> void:
	var fire = fire_textures[current_number_of_perfect_shot]
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(fire, "scale", Vector2.ZERO, 0.5)
	tween.tween_callback(func(): fire.hide())

func display_fire() -> void:
	var fire = fire_textures[current_number_of_perfect_shot - 1]
	fire.show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(fire, "scale", Vector2(3, 3), 0.1)
	tween.tween_property(fire, "scale", Vector2.ONE, 0.2)
	await tween.finished

func on_score_received(score_value: int) -> void:
	AudioManager.play_repair_sound()
	multiplier = 1.0 + (current_number_of_perfect_shot - 1)
	score_value *= multiplier
	score_buffer += score_value

	if score_buffer > 0:
		if score_buffer_tween and score_buffer_tween.is_running():
			score_buffer_tween.kill()
		score_buffer_label.text = "+" + str(score_buffer)
		score_buffer_label.global_position = score_label_original_position
		score_buffer_label.modulate.a = 1
		var buffer_tween = create_tween()
		buffer_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		buffer_tween.tween_property(score_buffer_label, "scale", Vector2(1.2, 1.2), 0.1)
		buffer_tween.tween_property(score_buffer_label, "scale", Vector2.ONE, 0.1)
	
	buffer_timer.start()

func _transfer_buffer_to_score() -> void:
	if score_buffer <= 0 or is_transferring_score:
		return
	AudioManager.reset_repair_sound_pitch()
	is_transferring_score = true
	var buffer_amount = score_buffer
	if buffer_amount >= treshold_to_congratulate_player:
		Events.on_player_congratulated.emit()
	score_buffer = 0
	
	score_buffer_tween = create_tween()
	score_buffer_tween.set_parallel()
	score_buffer_tween.tween_property(score_buffer_label, "modulate:a", 0, 0.1)
	var target_position = score_buffer_label.global_position
	target_position.y -= 100
	score_buffer_tween.tween_property(score_buffer_label, "global_position", target_position, 0.1)
	var start_score = current_score
	current_score += buffer_amount
	
	var score_tween = create_tween()
	score_tween.tween_method(update_score_display, start_score, current_score, 0.2)
	await score_tween.finished
	score_buffer_label.position = score_label_original_position
	
	var intensity = clamp(buffer_amount / 10.0, 1.0, 1.3)
	var celebration_tween = create_tween()
	celebration_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	celebration_tween.tween_property(score_label, "scale", Vector2(1.2, 1.2) * intensity, 0.1)
	celebration_tween.tween_property(score_label, "rotation_degrees", randf_range(-10, 10) * intensity, 0.05)
	celebration_tween.tween_property(score_label, "rotation_degrees", 0, 0.05)
	celebration_tween.tween_property(score_label, "scale", Vector2.ONE, 0.1)
	
	is_transferring_score = false
	
	if score_buffer > 0:
		buffer_timer.start()

func update_score_display(value: int) -> void:
	score_label.text = str(value)

func spawn_score_component(machine: Machine) -> void:
	var score_component = score_ui_component_scene.instantiate() as Control
	var canvas_transform = get_viewport().get_canvas_transform()
	var screen_pos = canvas_transform * machine.global_position
	screen_pos.y -= 150
	screen_pos.x -= 50
	score_component.global_position = screen_pos
	$PowerUpContainer.add_child(score_component)
	score_component.show_score(machine.score_value)

	var target_pos = score_label_original_position
	target_pos.x += score_buffer_label.size.x / 4
	target_pos.y -= score_buffer_label.size.y / 2
	var tween = create_tween()
	tween.tween_property(score_component, "global_position", target_pos, 0.2).set_delay(0.4)
	tween.tween_property(score_component, "scale", Vector2.ZERO, 0.2)
