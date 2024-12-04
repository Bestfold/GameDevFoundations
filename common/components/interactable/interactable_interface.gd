extends Node
class_name InteractableInterface

enum Type {NONE, COMPUTER, VEHICLE, CHAIR, SCREEN, BUTTON}

@export var interaction_type :Type

@export var interact_prompt: String = ""
#@export var parent: Node3D
@export var interact_area: CollisionObject3D

@warning_ignore("unused_signal")
signal interacted_with(value)

func execute_interaction(_interacter):
	pass
