extends State

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
	update_positions()
	
	if Owner.recent_direction == direction and Owner.recent_jump == jump:
		return
	
	Owner.send_input(direction, jump)

func roll_towards_player():
	if position_to_player.x > still_range:
		direction = left_input
	elif position_to_player.x < -still_range:
		direction = right_input

func jump_towards_player() -> void:
	jump_on_rotation(abs(degrees_to_player), (still_range * 10))
	print("jumping towards player")

func jump_on_rotation(degrees, degree_range) -> void:
	if abs(body_rotation - degrees) <= degree_range:
		jump = true
		print(degrees_to_player)
		print(body_rotation)
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
	
	
func _on_roll_timer_timeout() -> void:
	if not active:
		return
	
	roll_towards_player()
	
	RollTimer.start()
