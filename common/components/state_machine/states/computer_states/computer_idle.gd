extends ComputerStateInterface
class_name ComputerIdle

@export var computer_focus: ComputerStateInterface
@export var computer_leave: ComputerStateInterface

func enter():
	super()
	print("ComputerIdle entered")


func exit():
	pass

func process_physics(delta: float) -> State:
	var interactable_type = InteractableInterface.Type.NONE

	# Interactions from table:
	interactable_type = can_interact_component.handle_physics(delta)

	match interactable_type:
		InteractableInterface.Type.SCREEN:
			return computer_focus
		_: # Default (Type.NONE)
			pass

	if can_interact_component.leave_interact_state():
		return computer_leave

	return null


func process_input(event: InputEvent) -> State:
	look_component.handle_input(event, move_speed, lerp_val)
	return null

func process_frame(_delta: float) -> State:
	return null
