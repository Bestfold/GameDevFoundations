extends Node

class_name State

# State base class

@export var animation_name: String
@export var move_speed: float = 5
@export var lerp_val: float = 0.3

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")

# Holds a refrence to grandparent CharacterBody so that the body can be
#  controlled by the state
var parent: CharacterBody3D
var animation_player: AnimationPlayer
var move_component: MovementInterface
var look_component: LookInterface

func enter():
	animation_player.play(animation_name)

func exit():
	pass

func process_physics(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null





func rotate_character(event: float) -> void:
	parent.armature.rotation.y = -event * 0.005
