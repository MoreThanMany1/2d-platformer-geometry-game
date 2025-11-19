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
var position_to_player : Vector2
var angle_to_player : float
var degrees_to_player : float

#Chaser body tracking
var body_position : Vector2
var body_rotation : float

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
	if Owner.recent_direction == direction and Owner.recent_jump == jump:
		return
	
	Owner.send_input(direction, jump)

func roll_towards_player():
	update_positions()
	
	if position_to_player.x > still_range:
		direction = right_input
	elif position_to_player.x < -still_range:
		direction = left_input
	
	var old_position_to_player := position_to_player
	
	update_positions()
	
	if abs(position_to_player) > abs(old_position_to_player):
		direction = direction * -1

func jump_on_rotation(degrees, degree_range) -> void:
	update_positions()
	
	if abs ( abs(degrees_to_player) - abs(body_rotation) ) > degree_range:
		jump = true
	else:
		jump = false

func update_positions() -> void:
	update_player_position()
	update_chaser_position()
	
func update_player_position() -> void:
	player_position = Player.global_position
	position_to_player = body_position - player_position
	angle_to_player = position_to_player.angle()
	degrees_to_player = rad_to_deg(angle_to_player)

func update_chaser_position() -> void:
	body_position = ChaserBody.global_position
	body_rotation = ChaserBody.rotation_degrees
	
	
func _on_roll_timer_timeout() -> void:
	if not active:
		return
	
	roll_towards_player()
	
	RollTimer.start()
