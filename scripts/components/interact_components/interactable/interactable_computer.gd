extends InteractableInterface
class_name InteractableComputer

@export var debug_room_name = "room_1"

func execute_interaction(interacter):
	print("Test interactable interacted B>")

	if interacter is PlayerCharacter:
		interacted_with.emit(debug_room_name)
		print("interactable pc emitted: " + debug_room_name)
		
		interacter.position = MultiplayerManager.respawn_point
