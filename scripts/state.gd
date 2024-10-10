extends Node

class_name State

# State base class

signal state_transition

func Enter():
	pass

func Exit():
	pass

func _ready() -> void:
	pass

# Relayed _process function from state_machine
func Update(_delta:float):
	pass
