extends CanInteractInterface
class_name CanInteractSingleplayerPlayer

func get_request_for_interaction():
	if parent.is_controlable:
		return Input.is_action_just_pressed("interact")
	return false
