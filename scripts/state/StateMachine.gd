extends Node
class_name StateMachine

var states := {}
var current_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			if child.starting_state:
				current_state = child.starting_state

func change_state(new_state : State) -> void:
	current_state.exit()
	new_state.enter()
	
	current_state = new_state
	
