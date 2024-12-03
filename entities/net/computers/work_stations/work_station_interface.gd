extends Node3D
class_name WorkStationInterface

@export var user_return_position: Node3D
@export var user_position: Node3D
@export var user_sitting: bool
@export var screen_camera_position: Node3D

@onready var interactable_body:= %InteractableBody

var user_position_to_computer_angle: float

var screen_pos_to_user_pos: Vector3 

var occupied: bool = false:
	set(value):
		if occupied == value:
			return
		occupied = value
		if MultiplayerManager.multiplayer_mode_enabled:
			replicate_occupied.rpc(value)


@rpc("any_peer", "call_remote")
func replicate_occupied(value: bool):
	#print("replicating occupation of WorkStation: " + str(value))
	occupied = value
