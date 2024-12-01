extends Character
class_name PlayerCharacter

# Menu is visible and should capture mouse and remove control over character
@export var menu_visible := false

var sitting := false

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


func set_menu_visible(value: bool):
	menu_visible = value
	set_controlable(!value)


func toggle_menu_control(value: bool):
	if not sitting:
		set_menu_visible(value)
		look_component.capture_mouse()