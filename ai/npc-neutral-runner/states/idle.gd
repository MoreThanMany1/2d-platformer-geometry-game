extends State
class_name idle

@export_group("Detection Area")
@onready var detect_player = $"../../PlayerDetection"

@export_group("NPC Movement")
@export var jump_height := 900.0
@export var jump_length := 900.0
@export var alert_jump_height := 900
var alert_jump := false

func Enter():
	pass 
	
func Update(_delta: float):
	pass
	
func Physics_Update(body: RigidBody2D, _delta: float):
	if alert_jump:
		body.linear_velocity.y = -alert_jump_height
		alert_jump = false

func Integrate_Update(_state):
	pass

func Exit():
	pass

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		alert_jump = true
