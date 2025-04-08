extends Node2D

@onready var laser: Area2D = $Laser
@onready var bottom_pipe: Area2D = $BottomPipe
@onready var top_pipe: Area2D = $TopPipe

var speed: float = 120.0
const OFF_SCREEN: float = 100.0

var _gap_size: float = 250.0

func _ready() -> void:
	if not top_pipe or not bottom_pipe or not laser:
		push_error("No se encontraron TopPipe, BottomPipe o Laser")
		return

	top_pipe.position.y = -_gap_size / 2.0
	bottom_pipe.position.y = _gap_size / 2.0
	laser.position.y = 0.0 

func die() -> void:
	queue_free()

func _on_screen_exited() -> void:
	die()

func _on_pipe_body_entered(body: Node2D) -> void:
	if body is Tappy:
		body.die()

func _on_laser_body_entered(body: Node2D) -> void:
	if body is Tappy:
		laser.body_entered.disconnect(_on_laser_body_entered)
		SignalHub.emit_on_point_scored()

func set_speed(new_speed: float) -> void:
	speed = new_speed

func set_gap_size(new_gap: float) -> void:
	_gap_size = new_gap

	if top_pipe and bottom_pipe:
		top_pipe.position.y = -new_gap / 2.0
		bottom_pipe.position.y = new_gap / 2.0

	if laser:
		laser.position.y = 0.0

		var laser_shape = laser.get_node("CollisionShape2D").shape
		if laser_shape is RectangleShape2D:
			laser_shape.size.y = new_gap

		if laser.has_node("Sprite2D"):
			var sprite = laser.get_node("Sprite2D")
			var base_height = sprite.texture.get_height()
			if base_height > 0:
				sprite.scale.y = new_gap / base_height
