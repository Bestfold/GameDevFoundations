extends CanInteractInterface
class_name CanInteractMultiplayerPlayer


var replicated_type: InteractableInterface.Type = InteractableInterface.Type.NONE

var replicated_wants_to_escape: bool = false


func get_request_for_interaction(interactable):
	if interact_cooldown_active:
		return _NONE
		


	if multiplayer.is_server() && interactable:
		if parent.is_controlable && %InputSynchronizer.do_interact:
			if not interactable.available:
				return _NONE
			interactable.execute_interaction(parent)
			last_interactable = interactable

			var interaction_type = interactable.interaction_type
			replicate_interaction.rpc(interaction_type)

			return interaction_type
	else:
		if not replicated_type == _NONE:
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


func message_prompt(interactable: InteractableInterface):
	if multiplayer.get_unique_id() != parent.player_id:
		return

	if not text_label:
		push_warning("CanInteractInterface:message_prompt: TEXT_LABEL == NULL")
		return

	message = ""

	if interactable:
		message = interactable.interact_prompt
		if not interactable.available:
			message = "Interaction Unavailable"

	text_label.text = message





@rpc("any_peer", "call_remote")
func replicate_interaction(type: InteractableInterface.Type):	
	replicated_type = type 

@rpc("any_peer", "call_remote")
func replicate_wants_to_escape(value: bool):	
	replicated_wants_to_escape = value
