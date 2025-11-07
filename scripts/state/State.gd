extends Node
class_name State

@export_group("Node Connections")
@export var Owner : Node
@export var StateController : Node

@export_group("Defaults")
@export var direction := Vector2.ZERO
@export var jump := false

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
