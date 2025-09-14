extends ComputerStateInterface
class_name ComputerFocus

@export var computer_idle: ComputerStateInterface
@export var computer_leave: ComputerStateInterface

func enter():
	super()
	print("ComputerFocus entered")
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	if is_server_or_singleplayer():
		parent.set_at_desktop(true)
		#parent.spring_arm.global_position = computer_workstation.screen_camera_position.global_position
		var camera_position_offset = Vector3(
				-abs(parent_state.computer_workstation.screen_pos_to_user_pos.x), 
				-abs(parent.spring_arm_pivot.position.y -0.5 - parent_state.computer_workstation.screen_pos_to_user_pos.y), 
				-abs(parent_state.computer_workstation.screen_pos_to_user_pos.z)
			)

		parent.add_camera_position_offset(camera_position_offset)

		var camera_rotation = Vector3(0, parent_state.computer_workstation.global_rotation.y + PI, 0)
		parent.set_camera_rotation(camera_rotation)


func exit():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if is_server_or_singleplayer():
		parent.set_at_desktop(false)

		var camera_position_offset = Vector3(
				abs(parent_state.computer_workstation.screen_pos_to_user_pos.x), 
				abs(parent.spring_arm_pivot.position.y -0.5 - parent_state.computer_workstation.screen_pos_to_user_pos.y) ,
				abs(parent_state.computer_workstation.screen_pos_to_user_pos.z)
			)
		
		parent.add_camera_position_offset(camera_position_offset)

func process_physics(_delta: float) -> State:
	if can_interact_component.leave_interact_state():
		return computer_idle

	return null

func process_input(event: InputEvent) -> State:
	if is_server_or_singleplayer():
		var sub_viewport: SubViewport = parent_state.computer_workstation.computer.sub_viewport
		sub_viewport.push_input(event)
		sub_viewport.set_input_as_handled() # Unsure if this makes it so things outside of 
		# viewport can be interacted with, which is the idea.
		
	return null

func process_frame(_delta: float) -> State:
	return null
