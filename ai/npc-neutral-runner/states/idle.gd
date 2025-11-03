extends State
class_name idle

@export_group("Gravity")
@export var gravity_strength := 980.0
@export var gravity_direction := Vector2.DOWN
@export var gravity_angle := gravity_direction.angle() - deg_to_rad(90)
@export var possible_gravity_directions := [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]

func Enter():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass

func Integrate_Update(state):
	state.linear_velocity += gravity_direction * gravity_strength * state.step

func Exit():
	pass
