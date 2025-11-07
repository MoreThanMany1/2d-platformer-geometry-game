extends State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if Owner.recent_direction != direction or Owner.recent_jump != jump:
		Owner.send_input(direction, jump)
