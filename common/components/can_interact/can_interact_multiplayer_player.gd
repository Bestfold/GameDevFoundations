extends CanInteractInterface
class_name CanInteractMultiplayerPlayer

var wants_interact: bool = false

func get_request_for_interaction():
	if multiplayer.is_server():
		return %InputSynchronizer.do_interact

	return false

#@rpc("any_peer", "call_remote")
#func replicate_interaction(value: bool):
#	wants_interact = value 
#	print(wants_interact)