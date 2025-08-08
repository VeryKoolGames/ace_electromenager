extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score_manager: ScoreManager = $"../GameUI/ScoreManager"
@onready var score_label: RichTextLabel = $Star/ScoreLabel


func _ready() -> void:
	Events.on_game_timer_ended.connect(on_game_ended)

func on_game_ended() -> void:
	PlayerData.score = score_manager.current_score
	show()
	animation_player.play("end_game_enter")
	await get_tree().create_timer(1.5).timeout
	score_label.text = "[b]%d[/b]\nPTS" % score_manager.current_score
