extends InteractableInterface
class_name InteractableComputer

@export var debug_room_name = "room_1"

func execute_interaction(interacter):
	#print("Test interactable interacted B>")

	if interacter is PlayerMultiplayer:
		interacted_with.emit(debug_room_name, interacter.player_id)

		#interacter.position = MultiplayerManager.respawn_point
		
	elif interacter is PlayerSingleplayer:
		interacted_with.emit(debug_room_name, 0)

		#interacter.position = MultiplayerManager.respawn_point
