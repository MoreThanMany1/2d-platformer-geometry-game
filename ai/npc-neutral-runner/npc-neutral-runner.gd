extends RigidBody2D

@export_group("State Machine")
@onready var state_machine:= $StateMachine
var states: Dictionary = {}
@export var initial_state: State
var current_state: State

@export_group("Gravity")
@export var gravity_strength := 980.0
@export var gravity_direction := Vector2.DOWN
@export var gravity_angle := gravity_direction.angle() - deg_to_rad(90)
@export var possible_gravity_directions := [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]

func _ready():
	for child in state_machine.get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
			
func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func _integrate_forces(state) -> void:
	if current_state:
		current_state.Integrate_Update(state)
		print("true")
	
func on_child_transition(state, new_state_name, new_state_variables):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter(new_state_variables)
	
	current_state = new_state
