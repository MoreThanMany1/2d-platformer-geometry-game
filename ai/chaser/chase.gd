extends ChaserState

@export_group("Chaser")
@export var ChaserBody : RigidBody2D

@export_group("Timers")
@export var RollTimer : Timer
@export var roll_timer_length := 1.0

@export_group("Tracking")
@export var still_range := 0.5

var awaiting_jump := false
var jump_target : Vector2


func on_enter() -> void:
	RollTimer.wait_time = roll_timer_length
	RollTimer.start()

func on_exit() -> void:
	RollTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	jump_target = player_position
	awaiting_jump = true
	
	if awaiting_jump:
		jump_towards_point(jump_target)
	
	send_input()

func roll_towards_player():
	if position_to_player.x > still_range:
		direction = left_input
	elif position_to_player.x < -still_range:
		direction = right_input
	
func _on_roll_timer_timeout() -> void:
	roll_towards_player()
	wall_check()
	
	RollTimer.start()
