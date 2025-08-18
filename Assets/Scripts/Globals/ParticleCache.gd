extends Node2D

var repair_particles = preload("res://Assets/Materials/p_réparation.tres")
var item_particles = preload("res://Assets/Materials/p_item_particle.tres")
var shoot_particles = preload("res://Assets/Materials/shoot_particles.tres")
var cicle_repair_particles = preload("res://Assets/Materials/p_circle_repair.tres")
var spike_repair_particles = preload("res://Assets/Materials/p_spike_repair.tres")
var power_up_circle = preload("res://Assets/Materials/p_power_up_circle.tres")
var power_up_bubbles = preload("res://Assets/Materials/p_power_up_bubbles.tres")
var perfect_shot_circle = preload("res://Assets/Materials/perfect_shot_circle.tres")
var perfect_shot_impact = preload("res://Assets/Materials/perfect_shot_impact.tres")
var normal_shot = preload("res://Assets/Materials/normal_shot_particles.tres")

var materials = [
	repair_particles,
	item_particles,
	shoot_particles,
	cicle_repair_particles,
	power_up_circle,
	power_up_bubbles,
	perfect_shot_circle,
	perfect_shot_impact,
	normal_shot
]

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	for material in materials:
		var instance = GPUParticles2D.new()
		instance.process_material = material
		instance.one_shot = true
		instance.emitting = true
		add_child(instance)
