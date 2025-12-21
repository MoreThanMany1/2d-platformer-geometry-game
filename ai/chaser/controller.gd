extends ChaserState

@export_group("Input")
@export var input_left := "chaser_left"
@export var input_right := "chaser_right"
@export var input_jump := "chaser_jump"

var input_direction : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	determine_movement()
	
	send_input()

func determine_movement() -> void:
	input_direction = Input.get_axis(input_left, input_right)
	
	if Input.is_action_just_pressed(input_jump): 
		jump = true
	else: 
		jump = false
	
	if input_direction == 0:
		direction = Vector2.ZERO
		return
	
	if input_direction > 0:
		direction = left_input
		return
	
	if input_direction < 0:
		direction = right_input
		return
	
	
