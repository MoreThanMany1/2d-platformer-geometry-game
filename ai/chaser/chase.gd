extends ChaserState

@export_group("Chaser")
@export var ChaserBody : RigidBody2D

@export_group("Timers")
@export var RollTimer : Timer
@export var starting_roll_timer_length := 0.5
@export var roll_timer_extension_range := Vector2(0.5, 2.5)
@export var roll_timer_gap_close_min := 60.0
var roll_timer_length := starting_roll_timer_length

@export_group("Tracking")
@export var still_range := 0.5

var last_distance_to_player : float


func on_enter() -> void:
	RollTimer.wait_time = roll_timer_length
	RollTimer.start()

func on_exit() -> void:
	RollTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	send_input()

func roll_towards_player():
	var distance_to_player = Owner.body_position.distance_to(Owner.player_position)
	var force_same_direction : bool

	print(last_distance_to_player - distance_to_player)
	
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
	
	#Update this to account for y values... go for 
	
func _on_roll_timer_timeout() -> void:
	roll_towards_player()
	
	RollTimer.start(roll_timer_length)
	
	
	
