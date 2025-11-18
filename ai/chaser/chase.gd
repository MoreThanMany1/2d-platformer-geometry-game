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

#Chaser body tracking
var body_position : Vector2
var body_rotation : float
var body_to_player : Vector2

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
	
	if body_to_player.x > still_range:
		direction = right_input
	elif body_to_player.x < -still_range:
		direction = left_input
	
	var old_body_to_player := body_to_player
	
	update_positions()
	
	if abs(body_to_player) > abs(old_body_to_player):
		direction = direction * -1

func update_positions() -> void:
	update_player_position()
	update_chaser_position()
	
func update_player_position() -> void:
	player_position = Player.global_position

func update_chaser_position() -> void:
	body_position = ChaserBody.global_position
	body_rotation = ChaserBody.rotation_degrees
	body_to_player = body_position - player_position
	
	
func _on_roll_timer_timeout() -> void:
	if not active:
		return
	
	roll_towards_player()
	
	RollTimer.start()
