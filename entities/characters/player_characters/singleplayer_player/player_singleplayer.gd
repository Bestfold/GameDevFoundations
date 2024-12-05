extends PlayerCharacter

class_name PlayerSingleplayer

# Player is controlled by state-children, as exception to common standard.

const player_id = 0


func _ready() -> void:
	# Initialize state machine, passing a refrence of player to the states
	state_machine.init(self, animation_tree, skeleton, move_component, 
			look_component,	can_interact_component)

	look_component.capture_mouse()

	# Sets head invisible for player
	head_mesh.visible = false
	
	

func _unhandled_input(event: InputEvent) -> void:
	# Passes _unhandled_input() to state machine
	state_machine.process_input(event)


func _physics_process(delta: float) -> void:
	#var animation_state_machine = animation_tree["parameters/playback"]
	#print(animation_state_machine.get_current_node())
	# Passing function
	state_machine.process_physics(delta)

	# Monitoring
	#var_monitoring.emit(animation_tree.get("parameters/BlendSpace1D/blend_position"))

# Passing function
func _process(delta: float) -> void:
	state_machine.process_frame(delta)



func set_player_global_position(new_position: Vector3):
	position = new_position

func set_player_rotation(new_rotation: Vector3):
	set_camera_rotation(new_rotation)

func set_camera_position(new_position: Vector3):
	look_component.set_camera_position(new_position)

func add_camera_position_offset(position_offset):
	look_component.add_camera_position_offset(position_offset)

func set_camera_rotation(new_rotation: Vector3):
	look_component.set_camera_rotation(new_rotation)

func add_camera_rotation_offset(rotation_offset):
	look_component.add_camera_rotation_offset(rotation_offset)


func set_sitting(value: bool):
	sitting = value

func set_at_desktop(value: bool):
	at_desktop = value
