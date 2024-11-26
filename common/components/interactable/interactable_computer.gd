extends InteractableInterface
class_name InteractableComputer

@export var debug_room_name = "room_1"

func execute_interaction(interacter):
	print("Test interactable interacted B>")

	if interacter is PlayerMultiplayer:
		multiplayer_execute_interaction.rpc(debug_room_name, interacter.player_id)

		#interacter.position = MultiplayerManager.respawn_point
		
	elif interacter is PlayerSingleplayer:
		interacted_with.emit(debug_room_name, 0)

		#interacter.position = MultiplayerManager.respawn_point

@rpc("any_peer", "call_local")
func multiplayer_execute_interaction(room_name: String, player_id: int):
	print(str(Engine.get_instance_id()) + " called interaction")

	if multiplayer.is_server():
		interacted_with.emit(room_name, player_id)
