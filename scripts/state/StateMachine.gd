extends Node
class_name StateMachine

@export var Owner : Node
@export var StartingState : ChaserState

var states := {}
var current_state : ChaserState

func _ready() -> void:
	for child in get_children():
		if child is ChaserState:
			states[child.name] = child
			child.Owner = Owner
			child.StateController = self
	
	if StartingState:
		change_state(StartingState)
	else:
		push_error(str( get_path() ) + ": No starting state")

func change_state(new_state : ChaserState) -> void:
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
	
