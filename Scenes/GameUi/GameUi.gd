extends Control


const GAME_OVER = preload("res://assets/audio/game_over.wav")
@onready var current_level_label: Label = $MarginContainer/CurrentLevelLabel
@onready var level_up_label: Label = $MarginContainer/LevelUpLabel
@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var game_over_label: Label = $GameOverLabel
@onready var press_space_label: Label = $PressSpaceLabel
@onready var timer: Timer = $Timer
@onready var sound: AudioStreamPlayer = $Sound


var _can_press: bool = false
var _score: int = 0


func _ready() -> void:
	add_to_group("ui")
	_score = 0
	update_level_display(1)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit"):
		GameManager.load_main_scene()
	elif _can_press == true and event.is_action_pressed("jump"):
		ScoreManager.high_score = _score
		GameManager.load_main_scene()


func _enter_tree() -> void:
	SignalHub.on_point_scored.connect(on_point_scored)
	SignalHub.on_plane_died.connect(on_plane_died)


func on_point_scored() -> void:
	sound.play()
	_score += 1
	score_label.text = "%04d" % _score
	check_for_level_up()


func on_plane_died() -> void:
	sound.stop()
	sound.stream = GAME_OVER
	sound.play()
	game_over_label.show()
	timer.start()


func _on_timer_timeout() -> void:
	_can_press = true
	game_over_label.hide()
	press_space_label.show()

func check_for_level_up() -> void:
	var game_node = get_tree().get_first_node_in_group("game")
	if game_node and game_node.has_method("advance_level"):
		game_node.advance_level(_score)
		
func show_level_up_message(level: int) -> void:
	print("Nivel", level)

	level_up_label.text = "¡Nivel %d alcanzado!" % level
	level_up_label.visible = true

	await get_tree().create_timer(3.0).timeout

	level_up_label.visible = false

func update_level_display(level: int) -> void:
	current_level_label.text = "Nivel: %d" % level
