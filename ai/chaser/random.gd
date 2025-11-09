extends State

@export var RandomTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Owner.recent_direction == direction and Owner.recent_jump == jump:
		return
	
	Owner.send_input(direction, jump)

func randomize_input():
	if rng_boolean():
		direction = left_input
	else:
		direction = right_input
	
	if rng() < 0.8:
		jump = false
	else:
		jump = true
		direction = Vector2.ZERO
		

func _on_timer_timeout() -> void:
	randomize_input()
	
	if jump == true:
		RandomTimer.start(0.2)
	else:
		RandomTimer.start()
