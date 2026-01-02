extends ChaserState


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta) -> void:
	if Owner.recent_direction != direction or Owner.recent_jump != jump:
		send_input()
