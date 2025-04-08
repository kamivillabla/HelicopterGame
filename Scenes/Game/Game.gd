extends Node2D

const PIPES = preload("res://Scenes/Pipes/Pipes.tscn")

@onready var pipes_holder: Node = $PipesHolder
@onready var upper_point: Marker2D = $UpperPoint
@onready var lower_point: Marker2D = $LowerPoint
@onready var spawn_timer: Timer = $SpawnTimer

var current_level: int = 1

var levels = {
	1: {
		"pipe_speed": 80.0,
		"gap_size": 250.0,
		"spawn_interval": 3.0,
		"score_threshold": 3
	},
	2: {
		"pipe_speed": 160.0,
		"gap_size": 180.0,
		"spawn_interval": 2.0,
		"score_threshold": 6
	},
	3: {
		"pipe_speed": 240.0,
		"gap_size": 120.0,
		"spawn_interval": 1.5,
		"score_threshold": 99999
	}
}

func _ready() -> void:
	add_to_group("game")
	spawn_pipes()
	apply_difficulty()

	var ui = get_tree().get_first_node_in_group("ui")
	if ui and ui.has_method("update_level_display"):
		ui.update_level_display(current_level)

func _enter_tree() -> void:
	SignalHub.on_plane_died.connect(_on_plane_died)

func spawn_pipes() -> void:
	var config = levels[current_level]
	var gap_size = config["gap_size"]

	var np = PIPES.instantiate()

	var center_y: float = randf_range(
		upper_point.position.y + gap_size / 2.0,
		lower_point.position.y - gap_size / 2.0
	)

	np.position = Vector2(upper_point.position.x, center_y)
	np.set_gap_size(gap_size)
	np.set_process(false)
	pipes_holder.add_child(np)

func _on_spawn_timer_timeout() -> void:
	spawn_pipes()

func _on_plane_died() -> void:
	get_tree().paused = true

func apply_difficulty() -> void:
	var config = levels[current_level]
	spawn_timer.wait_time = config["spawn_interval"]

func advance_level(current_score: int) -> void:
	var next_level = current_level + 1
	if levels.has(next_level) and current_score >= levels[current_level]["score_threshold"]:
		current_level = next_level
		apply_difficulty()
		print("Nivel subido a:", current_level)

		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			if ui.has_method("show_level_up_message"):
				ui.show_level_up_message(current_level)
			if ui.has_method("update_level_display"):
				ui.update_level_display(current_level)

func _process(delta: float) -> void:
	var current_speed = levels[current_level]["pipe_speed"]
	for pipe in pipes_holder.get_children():
		pipe.position.x -= current_speed * delta

		if pipe.position.x < get_viewport_rect().position.x - 100.0:
			pipe.queue_free()
