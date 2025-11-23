extends StateMachine

@export var StateTimer : Timer

@export var ChaserBody : RigidBody2D

var last_position : Vector2
var current_position : Vector2

func _on_state_timer_timeout() -> void:
	current_position = ChaserBody.global_position
	
	if current_state == states["Idle"]:
		change_state(states["Random"])
		
	if current_state == states["Chase"]:
		if current_position == last_position:
			change_state(states["Random"])
		
		last_position = ChaserBody.global_position
		return
		
	if current_state == states["Random"]:
		change_state(states["Chase"])
		return
		
