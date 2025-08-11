extends CanvasLayer

var repair_particles = preload("res://Assets/Materials/p_réparation.tres")
var item_particles = preload("res://Assets/Materials/p_item_particle.tres")
var shoot_particles = preload("res://Assets/Materials/shoot_particles.tres")

var materials = [
	repair_particles,
	item_particles,
	shoot_particles
]

func _ready() -> void:
	for material in materials:
		var instance = GPUParticles2D.new()
		instance.process_material = material
		instance.one_shot = true
		instance.modulate = Color(1,1,1,0)
		instance.emitting = true
		add_child(instance)
