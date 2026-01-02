extends Node
class_name ChaserState

signal input(direction : Vector2, jump : bool)

@export_group("Node Connections")
@export var Owner : Node
@export var StateController : Node

@export_group("Starting Movement")
@export var direction := Vector2.ZERO
@export var jump := false

@export_group("Default Movement")
@export var right_input := Vector2(0, 1)
@export var left_input:= Vector2(1, 0)

@export_group("Active")
@export var active := false

func _ready() -> void:
	if not active:
		exit()

func enter():
	activation(true)
	on_enter()

func exit():
	activation(false)
	on_exit()

func activation(activate : bool):
	active = activate
	set_process(activate)
	set_physics_process(activate)

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func send_input() -> void:
	input.emit(direction, jump)

func rng():
	return randf()


	
