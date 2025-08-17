extends Control

@export var texture_rects: Array[TextureRect]   # Drag your TextureRects into this array in the inspector
@export var scale_speed: float = 2.0            # Speed of the pulse
@export var scale_amount: float = 0.05          # How much to scale (5% bigger)

var t: float = 0.0
var phase_offsets: Array[float] = []

func _ready() -> void:
	randomize()
	# Assign a random phase to each texture so they pulse differently
	phase_offsets.resize(texture_rects.size())
	for i in range(texture_rects.size()):
		phase_offsets[i] = randf() * TAU   # TAU = 2 * PI

func _process(delta: float) -> void:
	t += delta * scale_speed
	for i in range(texture_rects.size()):
		var tex = texture_rects[i]
		if tex:
			var pulse = 1.0 + sin(t + phase_offsets[i]) * scale_amount
			tex.scale = Vector2(pulse, pulse)
