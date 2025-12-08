extends RigidBody2D

@export_group("State Machine")
@onready var state_machine:= $StateMachine
@onready var initial_state:= $StateMachine/Idle
var states: Dictionary = {}
var current_state: State

@export_group("Gravity")
@export var gravity_strength := 980.0
@export var gravity_direction:= Vector2.DOWN
var possible_gravity_directions := [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]
var gravity_angle := gravity_direction.angle() - deg_to_rad(90)

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
		current_state.Physics_Update(self, delta)

func _integrate_forces(state) -> void:
	if current_state:
		current_state.Integrate_Update(state)
	state.linear_velocity += gravity_direction * gravity_strength * state.step
	
func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	
func stick() -> void:
	if not on_ground():
		return
	for raycast in raycasts:
		if raycast.is_colliding():
			gravity_change(raycast.get_collision_point() - self.global_position)
		
		
func gravity_change(stick_direction : Vector2) -> void:
	stick_direction = stick_direction.normalized()
	
	var closest_gravity_direction := Vector2.DOWN
	
	for possible_direction in possible_gravity_directions:
		if (possible_direction - stick_direction).length() < 1:
			closest_gravity_direction = possible_direction
		
	gravity_direction = closest_gravity_direction
	gravity_angle = gravity_direction.angle() - deg_to_rad(90)

func on_ground() -> bool:
	for ray in ground_raycasts.get_children():
		if ray.is_colliding():
			return true
	return false
