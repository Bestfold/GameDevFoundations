extends Node

class_name State

# State base class

@export var animation_state_name: String
@export var move_speed: float = 5
@export var lerp_val: float = 0.3

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")

# Holds a refrence to grandparent CharacterBody so that the body can be
#  controlled by the state
var parent: CharacterBody3D
var animation_tree: AnimationTree
var skeleton: Skeleton3D
var move_component: MovementInterface
var look_component: LookInterface
var can_interact_component: CanInteractInterface

func enter():
	#animation_tree.play(animation_name)
	#var animation_condition_path := "parameters/conditions/" + str(animation_condition_name)
	#animation_tree.set(animation_condition_path, true)
	var animation_state_machine = animation_tree["parameters/playback"]
	animation_state_machine.travel(animation_state_name)
	pass

func exit():
	#var animation_condition_path := "parameters/conditions/" + str(animation_condition_name)
	#animation_tree.set(animation_condition_path, false)
	pass

func process_physics(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

#func interacted(_interactable: InteractableInterface, _value):
#	return null
