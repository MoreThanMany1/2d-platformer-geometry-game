extends ChaserState

@export var RandomTimer : Timer

func on_enter() -> void:
	RandomTimer.start()

func on_exit() -> void:
	RandomTimer.stop()
	
func _process(delta: float) -> void:
	if Owner.recent_direction == direction and Owner.recent_jump == jump:
		return
	
	send_input()

func randomize_input():
	if rng() < 0.8:
		jump = false
	else:
		jump = true
	
	if jump:
		return
	
	if rng() < 0.5:
		direction = left_input
	else:
		direction = right_input
		

func _on_timer_timeout() -> void:
	if not active:
		return
		
	randomize_input()
	
	if jump == true:
		RandomTimer.start(0.2)
	else:
		RandomTimer.start()
