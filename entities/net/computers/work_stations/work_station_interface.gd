extends Node3D
class_name WorkStationInterface

@export var user_return_position: Node3D
@export var user_position: Node3D
@export var user_sitting: bool

@onready var interactable_body:= %InteractableBody

var user_position_to_computer_angle: float
