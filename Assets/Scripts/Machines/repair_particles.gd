extends Node2D
class_name RepairParticles

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var piques: GPUParticles2D = $Piques
@onready var cercle: GPUParticles2D = $Cercle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gpu_particles_2d.emitting = true
	piques.emitting = true
	cercle.emitting = true
	gpu_particles_2d.finished.connect(func(): queue_free())
