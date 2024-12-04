extends Character
class_name PlayerCharacter

# Menu is visible and should capture mouse and remove control over character
@export var menu_visible := false
@export var sitting_camera_offset := -0.5

# Child refrences
@onready var spring_arm: SpringArm3D = %SpringArm3D
@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var skeleton: Skeleton3D = %Skeleton3D
@onready var spring_arm_pivot: Node3D = %SpringArmPivot
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var head_mesh: MeshInstance3D = %Head
@onready var move_component: MovementInterface = $MoveComponent
@onready var look_component: LookInterface = $LookComponent
@onready var can_interact_component: CanInteractInterface = $CanInteract
@onready var head_bobbing: Node3D = %Head_bobbing
@onready var camera: Camera3D = %Camera3D
@onready var interact_ray: RayCast3D = %InteractRay


var sitting := false:
	set(value):
		sitting = value
		if value:
			look_component.add_camera_position_offset(Vector3(0, sitting_camera_offset, 0))
			# Setting collison mask to only get "TableInteractables"
			interact_ray.set_collision_mask_value(1, false)
			interact_ray.set_collision_mask_value(3, true)
		else:
			look_component.add_camera_position_offset(Vector3(0, -sitting_camera_offset, 0))
			interact_ray.set_collision_mask_value(1, true)
			interact_ray.set_collision_mask_value(3, false)

var at_desktop := false


func set_menu_visible(value: bool):
	menu_visible = value
	set_controlable(!value)


func toggle_menu_control(value: bool):
	if not sitting:
		set_menu_visible(value)
		look_component.capture_mouse()

func set_player_global_position(_new_position: Vector3):
	pass

func set_player_rotation(new_rotation: Vector3):
	set_camera_rotation(new_rotation)

func set_camera_position(_new_position: Vector3):
	pass

func add_camera_position_offset(_position_offset):
	pass

func set_camera_rotation(_new_rotation: Vector3):
	pass

func add_camera_rotation_offset(_position_offset):
	pass


func set_sitting(_value: bool):
	pass


func set_at_desktop(_value: bool):
	pass


#@rpc("any_peer", "call_remote")
#func replicate_remote_set_sitting(value: bool):
#	sitting = value
