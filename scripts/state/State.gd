extends Node
class_name State

@export_group("Node Connections")
@export var Owner : Node
@export var StateController : Node

@export_group("Starting Movement")
@export var direction := Vector2.ZERO
@export var jump := false

@export_group("Default Movement")
@export var right_input := Vector2(0, 1)
@export var left_input:= Vector2(1, 0)

@export_group("Ranodmization")
@export var random := 0

@export_group("Active")
@export var active := false

func enter():
	activation(true)

func exit():
	activation(false)

func activation(activate : bool):
	active = activate
	set_process(activate)
	set_physics_process(activate)

func rng():
	return randf()

func rng_boolean():
	if randi_range(0, 1) == 0:
		return true
	else:
		return false
	
