extends Node2D

@export_group("Nodes")
@export var ChaserBody : RigidBody2D

var recent_direction := Vector2.ZERO
var recent_jump := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func send_input(direction : Vector2, jump : bool):
	ChaserBody.input_left = direction.x
	ChaserBody.input_right = direction.y
	ChaserBody.input_jump = jump
	
	recent_direction = direction
	recent_jump = jump
