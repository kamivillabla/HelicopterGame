extends Node


const GAME = preload("res://Scenes/Game/Game.tscn")
const MAIN = preload("res://Scenes/Main/Main.tscn")
const SIMPLE_TRANSITION = preload("res://Scenes/SimpleTransition/SimpleTransition.tscn")
const COMPLEX_TRANSITION = preload("res://Scenes/ComplexTransition/ComplexTransition.tscn")

var next_scene: PackedScene


func add_complex() -> void:
	var ct = COMPLEX_TRANSITION.instantiate()
	add_child(ct)


func load_game_scene() -> void:
	next_scene = GAME
	add_complex()



func load_main_scene() -> void:
	next_scene = MAIN
	add_complex()
