extends Node2D

@export_group("Nodes")
@export var ChaserBody : RigidBody2D
@export var WallCast : RayCast2D

#Wall Detecting Raycast
var checking_for_walls := false
var wall_check_gaps := 18

var wall_positions := []

var recent_direction := Vector2.ZERO
var recent_jump := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func send_input(direction : Vector2, jump : bool):
	ChaserBody.input_left = direction.x
	ChaserBody.input_right = direction.y
	ChaserBody.input_jump = jump
	
	recent_direction = direction
	recent_jump = jump

func check_for_walls() -> Array:
	wall_positions = []
	WallCast.global_position = ChaserBody.global_position
	
	if WallCast.rotation_degrees >= 360:
		WallCast.rotation_degrees = 0
		
	while WallCast.rotation_degrees < 360:
		WallCast.rotation_degrees += wall_check_gaps
		
		await get_tree().process_frame
		
		if WallCast.is_colliding():
			wall_positions.append(WallCast.get_collision_point())
		
	return wall_positions
