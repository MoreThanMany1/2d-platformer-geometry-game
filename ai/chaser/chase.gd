extends ChaserState

@export_group("Chaser")
@export var ChaserBody : RigidBody2D

@export_group("Timers")
@export var RollTimer : Timer
@export var starting_roll_timer_length := 0.3
@export var roll_timer_extension_range := Vector2(0.5, 2.5)
@export var roll_timer_gap_close_min := 60.0
var roll_timer_length := starting_roll_timer_length

@export_group("Tracking")
@export var still_range := 0.5
@export var player_high_speed := 250.0
@export var dont_jump_min := 700.0

var last_distance_to_player : float


func on_enter() -> void:
	RollTimer.wait_time = roll_timer_length
	RollTimer.start()

func on_exit() -> void:
	RollTimer.stop()

func _process(_delta: float) -> void:
	send_input()

func roll_towards_player(): #If this is called more often, adjust roll_timer_close_gap_min to be smaller
	var distance_to_player = Owner.body_position.distance_to(Owner.player_position)
	var force_same_direction : bool
	
	if last_distance_to_player - distance_to_player < roll_timer_gap_close_min:
		roll_timer_length += randf_range(roll_timer_extension_range.x, roll_timer_extension_range.y)
		force_same_direction = false
	else:
		roll_timer_length = starting_roll_timer_length
		force_same_direction = true
	
	last_distance_to_player = Owner.body_position.distance_to(Owner.player_position)
	
	if force_same_direction:
		return
	
	if Owner.position_to_player.x > still_range:
		direction = left_input
	elif Owner.position_to_player.x < -still_range:
		direction = right_input
	
	#Update this to account for y values

func determine_awaiting_jump() -> void:
	var min_player_velocity_for_jump := 700
	var max_y_value_diff_for_jump := 50
	
	if Owner.body_position.distance_to(Owner.player_position) > dont_jump_min and Owner.wall_to_player:
		Owner.awaiting_jump = false
		return
	
	if Owner.player_velocity.length() > min_player_velocity_for_jump:
		Owner.jump_target = Owner.player_position
		Owner.awaiting_jump = true
		return
		
	if Owner.body_gravity != Vector2.DOWN:
		Owner.awaiting_jump = false
		return
	
	if abs(Owner.body_position.y - Owner.player_position.y) > max_y_value_diff_for_jump:
		if rng() > 0.8:
			Owner.awaiting_jump = false
			return
	
	if Owner.body_position.distance_to(Owner.player_position) < dont_jump_min:
		Owner.jump_target = Owner.player_position
		Owner.awaiting_jump = true
		return
	
func _on_roll_timer_timeout() -> void:
	roll_towards_player()
	determine_awaiting_jump()
	
	RollTimer.start(roll_timer_length)
