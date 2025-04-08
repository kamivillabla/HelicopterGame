extends Control


@onready var high_score_label: Label = $MarginContainer/HighScoreLabel


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		GameManager.load_game_scene()


func _ready() -> void:
	get_tree().paused = false
	high_score_label.text = "%04d" % ScoreManager.high_score
