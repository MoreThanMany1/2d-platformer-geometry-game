extends State

var Player : RigidBody2D
var player_position : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_tree().get_first_node_in_group("player")
	update_player_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Owner.recent_direction == direction and Owner.recent_jump == jump:
		return
	
	Owner.send_input(direction, jump)
	
func update_player_position() -> void:
	player_position = Player.global_position
