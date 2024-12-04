extends CanInteractInterface
class_name CanInteractSingleplayerPlayer

func get_request_for_interaction(child):
	if interact_cooldown_active:
		return InteractableInterface.Type.NONE

	if parent.is_controlable && Input.is_action_just_pressed("interact"):
			#print("Interactable: " + str(child))
			#print("Interactable's owner: " + str(child.owner))
			child.execute_interaction(parent)
			last_interactable = child
			text_label.text = ""
			
			return child.interaction_type
	
	return InteractableInterface.Type.NONE


func leave_interact_state() -> bool:
	if parent.is_controlable:
		return Input.is_action_pressed("escape")
	return false
