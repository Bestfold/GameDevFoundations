extends CanInteractInterface
class_name CanInteractSingleplayerPlayer


func get_request_for_interaction(child):
	if interact_cooldown_active || not child:
		return _NONE

	if parent.is_controlable && Input.is_action_just_pressed("interact"):
			#print("Interactable: " + str(child))
			#print("Interactable's owner: " + str(child.owner))
			child.execute_interaction(parent)
			last_interactable = child
			
			return child.interaction_type
	
	return _NONE

func get_request_for_leave_interact_state() -> bool:
	if parent.is_controlable:
		return Input.is_action_pressed("escape")
	return false
