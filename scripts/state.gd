extends Node

class_name State

# State base class

@export var animation_name: String
@export var move_speed: float = 5
@export var lerp_val: float = 0.3

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")

# Holds a refrence to grandparent CharacterBody so that the body can be
#  controlled by the state
var parent: Player

func enter():
	parent.animation_player.play(animation_name)
	pass

func exit():
	pass

func process_physics(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null


# Free mouse movement
# Specificly for use with "stock_character_headless", or just "Player"
func mouse_movement_free(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		parent.spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		parent.spring_arm.rotate_x(-event.relative.y * 0.005)
		parent.spring_arm.rotation.x = clamp(parent.spring_arm.rotation.x, -PI/2, PI/2)
		# Trenger å bytte fra velocity til spring_arm_pivot sin vector om den skal rotere med kamera
		parent.armature.rotation.y = lerp_angle(parent.armature.rotation.y, 
				atan2(parent.velocity.x, parent.velocity.z), lerp_val)
