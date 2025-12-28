extends Node2D

@export_group("Nodes")
@export var ChaserBody : RigidBody2D
@export var WallCast : RayCast2D
@export var ToPlayerCast : RayCast2D
@export var ChaserStateMachine : StateMachine

var recent_direction := Vector2.ZERO
var recent_jump := false

var awaiting_jump := false
var jump_target : Vector2
var recent_rotation_for_jump : float

#Player tracking
var Player : RigidBody2D
var player_position : Vector2
var player_gravity : Vector2
var player_velocity : Vector2
var position_to_player : Vector2
var angle_to_player : float
var degrees_to_player : float
var wall_to_player : bool

#Chaser body tracking
var body_position : Vector2
var body_rotation : float
var body_gravity : Vector2

#Wall Detecting Raycast
var checking_for_walls := false
var wall_check_gaps := 18
var detected_walls := []
var wall_up : bool
var wall_down : bool
var wall_left : bool
var wall_right : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_tree().get_first_node_in_group("player")
	
	for state in ChaserStateMachine.get_children():
		if state is ChaserState:	
			state.input.connect(send_input)
	
	detected_walls.append(Vector2.ZERO)

func _physics_process(_delta: float) -> void:
	update_positions()
	
	if awaiting_jump:
		jump_towards_point(jump_target)
	

func send_input(direction : Vector2, jump : bool):
	ChaserBody.input_left = direction.x
	ChaserBody.input_right = direction.y
	ChaserBody.input_jump = jump
	
	recent_direction = direction
	recent_jump = jump

func send_movement(direction : Vector2):
	ChaserBody.input_left = direction.x
	ChaserBody.input_right = direction.y
	recent_direction = direction

func send_jump(jump : bool):
	ChaserBody.input_jump = jump
	recent_jump = jump

func check_for_walls(central_position) -> void:
	var wall_positions := []
	var recent_detection : bool
	
	wall_positions = []
	WallCast.global_position = central_position
	
	for angle in range(0.0, 360.0, wall_check_gaps):
		WallCast.rotation_degrees = angle
		
		if WallCast.is_colliding():
			recent_detection = true
			wall_positions.append(WallCast.get_collision_point())
		else:
			recent_detection = false
		
		match angle:
			0.0:
				wall_right = recent_detection
			90.0:
				wall_up = recent_detection
			180.0:
				wall_left = recent_detection
			270.0:
				wall_down = recent_detection
		
	if wall_positions.size() == 0:
		push_warning("No walls detected by Chaser")
	
	detected_walls = wall_positions

func find_wall_closest_to(point):
	var closest_wall = detected_walls[0]
	
	for wall in detected_walls:
		if wall.distance_squared_to(point) < closest_wall.distance_squared_to(point):
			closest_wall = wall
	
	return closest_wall

func jump_towards_point(point : Vector2) -> void:
	var degrees_to_point := rad_to_deg((point - body_position).angle())
	degrees_to_point = abs(degrees_to_point) #Note to self, maybe remove this if needed for gravity compensation
	
	var distance_to_point := body_position.distance_to(point)
	
	if distance_to_point >= 750:
		return
	
	jump_on_rotation(-degrees_to_point, 1) 

func jump_on_rotation(degrees, degree_range) -> bool:
	recent_rotation_for_jump = degrees
	
	if abs(body_rotation - degrees) <= degree_range:
		send_jump(true)
		awaiting_jump = false
		return true
	else:
		send_jump(false)
		return false


func update_positions() -> void:
	body_position = ChaserBody.global_position
	body_rotation = ChaserBody.rotation_degrees
	body_gravity = ChaserBody.gravity_direction
	
	player_position = Player.global_position
	player_gravity = Player.gravity_direction
	player_velocity = Player.linear_velocity
		
	position_to_player = player_position - body_position
	angle_to_player = position_to_player.angle()
	degrees_to_player = rad_to_deg(angle_to_player)
	
	wall_to_player = check_for_wall_to_player()

func check_for_wall_to_player() -> bool:
	ToPlayerCast.global_position = ChaserBody.global_position
	ToPlayerCast.target_position = position_to_player
	
	return ToPlayerCast.is_colliding()
	
	
	
