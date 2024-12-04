extends CanInteractInterface
class_name CanInteractMultiplayerPlayer


var replicated_type: InteractableInterface.Type = InteractableInterface.Type.NONE

var replicated_wants_to_escape: bool = false


func get_request_for_interaction(child):
	if interact_cooldown_active:
		return _NONE

	if multiplayer.is_server() && child:
		if parent.is_controlable && %InputSynchronizer.do_interact:
			print("Wants to interact")
			print("Interactable: " + str(child))
			print("Interactable's owner: " + str(child.owner))
			child.execute_interaction(parent)
			last_interactable = child

			var interaction_type = child.interaction_type
			replicate_interaction.rpc(interaction_type)

			return interaction_type
	else:
		if not replicated_type == _NONE:
			print("Replicated type: " + str(replicated_type))
			var temporary_type = replicated_type
			replicated_type = _NONE
			return temporary_type
	
	return _NONE


func get_request_for_leave_interact_state() -> bool:
	if multiplayer.is_server():
		if parent.is_controlable && %InputSynchronizer.do_escape:
			replicate_wants_to_escape.rpc(true)
			return true
	else:
		if replicated_wants_to_escape:
			replicated_wants_to_escape = false
			return true
	return false



@rpc("any_peer", "call_remote")
func replicate_interaction(type: InteractableInterface.Type):	
	replicated_type = type 
	print(replicated_type)

@rpc("any_peer", "call_remote")
func replicate_wants_to_escape(value: bool):	
	replicated_wants_to_escape = value
