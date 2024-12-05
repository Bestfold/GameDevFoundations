extends Node3D
class_name WorkStationInterface

@export var user_return_position: Node3D
@export var user_position: Node3D
#@export var user_sitting: bool
@export var screen_camera_position: Node3D

@onready var interactable_body:= %InteractableBody

var user_position_to_computer_angle: float

var screen_pos_to_user_pos: Vector3 

var occupied: bool = false:
	set(value):
		print("Setting occupied at WorkStation to: " + str(value))
		if occupied == value:
			return
		occupied = value
		print("Occupied at WorkStation set to: " + str(occupied))
		interactable_body.set_available(!value)
