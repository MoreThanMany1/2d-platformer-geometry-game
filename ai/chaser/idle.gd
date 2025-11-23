extends State


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if Owner.recent_direction != direction or Owner.recent_jump != jump:
		Owner.send_input(direction, jump)
