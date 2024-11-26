extends CanInteractInterface
class_name CanInteractMultiplayerPlayer

func get_request_for_interaction():
	if multiplayer.get_unique_id() == parent.player_id && parent.is_controlable:
		return Input.is_action_just_pressed("interact")
	return false
