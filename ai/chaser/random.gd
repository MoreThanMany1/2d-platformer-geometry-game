extends State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Owner.recent_direction != direction or Owner.recent_jump != jump:
		randomize_input()

func randomize_input():
	if rng_boolean() == true:
		direction = left
	else:
		direction = right
	
	if rng() > 0.95:
		jump = true
		
	
	
	
