extends Node
class_name StateMachine

@export var Owner : Node
@export var StartingState : State

var states := {}
var current_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Owner = Owner
	
	if StartingState:
		current_state = StartingState
	else:
		push_error(str( get_path() ) + ": No starting state")

func change_state(new_state : State) -> void:
	current_state.exit()
	new_state.enter()
	
	current_state = new_state
	
