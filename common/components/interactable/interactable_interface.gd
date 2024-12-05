extends Node
class_name InteractableInterface

enum Type {NONE, LEAVE_STATE, COMPUTER, VEHICLE, CHAIR, SCREEN, BUTTON}

@export var interaction_type :Type

@export var interact_prompt: String = ""

@export var interact_area: CollisionObject3D

@export var available = true

@warning_ignore("unused_signal")
signal interacted_with(value)

func execute_interaction(_interacter):
	pass


func set_available(value: bool):
	print("Interactable set_available to: " + str(value))
	if available == value:
		return
	else:
		print("Setting available to: " + str(value))
		available = value
		print("Available set to: " + str(available))
		if MultiplayerManager.multiplayer_mode_enabled && multiplayer.is_server():
			print("Calling replicat available")
			replicate_remote_available.rpc(value)


@rpc("any_peer", "call_remote")
func replicate_remote_available(value: bool):
	print("replicating availability of interactable: " + str(value))
	available = value
	