extends InteractableInterface
class_name InteractableTest

func execute_interaction(interacter):
	print("Test interactable interacted B>")

	if interacter is Character:
		interacter.position = MultiplayerManager.respawn_point
