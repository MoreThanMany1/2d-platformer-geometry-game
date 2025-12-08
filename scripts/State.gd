extends Node
class_name State

signal Transitioned

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta: float):
	pass

func Physics_Update(_body: RigidBody2D, _delta: float):
	pass
	
func Integrate_Update(_state):
	pass
