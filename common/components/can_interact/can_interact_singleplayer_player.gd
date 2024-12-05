extends CanInteractInterface
class_name CanInteractSingleplayerPlayer


func get_request_for_interaction(interactable):
	if interact_cooldown_active || not interactable:
		return _NONE

	if not interactable.available:
		return _NONE

	if parent.is_controlable && Input.is_action_just_pressed("interact"):
			interactable.execute_interaction(parent)
			last_interactable = interactable
			
			return interactable.interaction_type
	
	return _NONE

func get_request_for_leave_interact_state() -> bool:
	if parent.is_controlable:
		return Input.is_action_pressed("escape")
	return false


func message_prompt(interactable: InteractableInterface):
	if not text_label:
		push_warning("CanInteractInterface:message_prompt: TEXT_LABEL == NULL")
		return

	message = ""

	if interactable:
		message = interactable.interact_prompt
		if not interactable.available:
			message = "Interaction Unavailable"

	text_label.text = message
