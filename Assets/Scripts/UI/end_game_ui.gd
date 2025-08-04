extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.on_game_timer_ended.connect(on_game_ended)

func on_game_ended() -> void:
	show()
	animation_player.play("end_game_enter")
