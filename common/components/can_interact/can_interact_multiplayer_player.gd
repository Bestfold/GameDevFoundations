extends CanInteractInterface
class_name CanInteractMultiplayerPlayer

var wants_interact: bool = false

func get_request_for_interaction():
	if wants_interact:
		wants_interact = false
		return true

	if multiplayer.get_unique_id() == parent.player_id && parent.is_controlable:
		wants_interact = Input.is_action_just_pressed("interact")
		if wants_interact:
			replicate_interaction.rpc()	

	return false

@rpc("any_peer", "call_local")
func replicate_interaction():
	wants_interact = true 
	#print(wants_interact)