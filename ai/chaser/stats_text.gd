extends RichTextLabel

@export var Owner : Node

var display_state : String
var display_position : String
var display_input : String
var display_rotation : String
var display_awaiting_jump : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_text()
	

func update_text() -> void:
	self.global_position = Vector2(Owner.body_position.x - 330, Owner.body_position.y - 450)
	
	if Owner.awaiting_jump:
		display_awaiting_jump = "Awaiting " + str(int(Owner.recent_rotation_for_jump)) + "°"
	else:
		display_awaiting_jump = ""
	
	display_state = str(Owner.ChaserStateMachine.current_state.name)
	display_position = str(int(Owner.body_position.x)) + " , " + str(int(Owner.body_position.y))
	display_input = str(Owner.recent_direction)
	display_rotation = str(int(Owner.body_rotation)) + "°"
	
	text = (
		display_state + 
		"\n" + 
		display_position + 
		"\n" + 
		display_input +
		"\n" + 
		display_rotation +
		"\n" + 
		display_awaiting_jump
		)
	
