extends State

@export_group("Idle Movement")
@export var idle_direction := Vector2.ZERO
@export var idle_jump := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if Owner.recent_direction != idle_direction or Owner.recent_jump != idle_jump:
		Owner.send_input(idle_direction, idle_jump)
