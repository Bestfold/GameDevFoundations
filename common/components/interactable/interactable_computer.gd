extends InteractableInterface
class_name InteractableComputer

func execute_interaction(interacter):
	print("Test interactable interacted B>")

	if interacter is PlayerMultiplayer:
		multiplayer_execute_interaction.rpc()

		#interacter.position = MultiplayerManager.respawn_point
		
	elif interacter is PlayerSingleplayer:
		interacted_with.emit()

		#interacter.position = MultiplayerManager.respawn_point

@rpc("any_peer", "call_local")
func multiplayer_execute_interaction():

	if multiplayer.is_server():
		interacted_with.emit()
