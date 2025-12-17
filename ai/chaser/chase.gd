extends ChaserState

@export_group("Chaser")
@export var ChaserBody : RigidBody2D

@export_group("Timers")
@export var RollTimer : Timer
@export var roll_timer_length := 1.0

@export_group("Tracking")
@export var still_range := 0.5

#Player tracking
var Player : RigidBody2D
var player_position : Vector2
var player_gravity : Vector2
var position_to_player : Vector2
var angle_to_player : float
var degrees_to_player : float

#Chaser body tracking
var body_position : Vector2
var body_rotation : float
var body_gravity : Vector2

var detected_walls := []
var closest_wall_to_player : Vector2

var awaiting_jump := false
var jump_target : Vector2


func on_enter() -> void:
	RollTimer.wait_time = roll_timer_length
	RollTimer.start()

func on_exit() -> void:
	RollTimer.stop()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	Player = get_tree().get_first_node_in_group("player")
	update_positions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	jump_target = player_position
	awaiting_jump = true
	
	if awaiting_jump:
		jump_towards_point(jump_target)
	
	send_input()

func roll_towards_player():
	update_positions()
	if position_to_player.x > still_range:
		direction = left_input
	elif position_to_player.x < -still_range:
		direction = right_input

func jump_towards_point(point : Vector2) -> void:
	var degrees_to_point := rad_to_deg((point - body_position).angle())
	degrees_to_point = abs(degrees_to_point) #Note to self, maybe remove this if needed for gravity compensation
	
	var distance_to_point := body_position.distance_to(point)
	
	if distance_to_point >= 550:
		return
	
	jump_on_rotation(-degrees_to_point, 1) #Not accurate

func jump_on_rotation(degrees, degree_range) -> void:
	update_positions()
	if abs(body_rotation - degrees) <= degree_range:
		jump = true
	else:
		jump = false
	
func update_positions() -> void:
	body_position = ChaserBody.global_position
	body_rotation = ChaserBody.rotation_degrees
	body_gravity = ChaserBody.gravity_direction
	
	player_position = Player.global_position
	player_gravity = Player.gravity_direction
	
	position_to_player = player_position - body_position
	angle_to_player = position_to_player.angle()
	degrees_to_player = rad_to_deg(angle_to_player)

func wall_check() -> void:
	update_positions()
	detected_walls = await Owner.check_for_walls()
	
	if detected_walls.size() == 0:
		push_error("No walls detected by Chaser")
		
	var closest_wall = detected_walls[0]
	
	for wall in detected_walls:
		if wall.distance_squared_to(player_position) < closest_wall.distance_squared_to(player_position):
			closest_wall = wall
	
	closest_wall_to_player = closest_wall
	
func _on_roll_timer_timeout() -> void:
	roll_towards_player()
	wall_check()
	
	RollTimer.start()
