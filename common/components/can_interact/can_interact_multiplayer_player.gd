extends CanInteractInterface
class_name CanInteractMultiplayerPlayer


var replicated_type: InteractableInterface.Type = InteractableInterface.Type.NONE

func get_request_for_interaction(child):
	if interact_cooldown_active:
		return InteractableInterface.Type.NONE

	if multiplayer.is_server():
		if parent.is_controlable && %InputSynchronizer.do_interact:

			#print("Interactable: " + str(child))
			#print("Interactable's owner: " + str(child.owner))
			child.execute_interaction(parent)
			last_interactable = child
			text_label.text = ""

			var interaction_type = child.interaction_type
			replicate_interaction.rpc(interaction_type)

			return interaction_type
	else:
		if not replicated_type == InteractableInterface.Type.NONE:
			var temporary_type = replicated_type
			replicated_type = InteractableInterface.Type.NONE
			return temporary_type
	
	return InteractableInterface.Type.NONE


func leave_interact_state() -> bool:
	if parent.is_controlable:
		return %InputSynchronizer.do_escape
	return false


@rpc("any_peer", "call_remote")
func replicate_interaction(type: InteractableInterface.Type):	
	replicated_type = type 
	print(replicated_type)