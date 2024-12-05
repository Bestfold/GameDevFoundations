extends InteractableInterface
class_name InteractableComputer

func execute_interaction(interacter):
	if interacter is PlayerMultiplayer:
		multiplayer_execute_interaction.rpc()
		
	elif interacter is PlayerSingleplayer:
		interacted_with.emit()


@rpc("any_peer", "call_local")
func multiplayer_execute_interaction():

	if multiplayer.is_server():
		interacted_with.emit()
