extends VBoxContainer

@onready var network_manager: Node = %NetworkManager
@onready var lobby_container: VBoxContainer = %LobbyContainer


#signal game_log(message: String)

signal enet_host()
signal enet_join()
signal steam_host()
signal steam_list_lobbies()
#signal steam_join()


func _ready():
	pass
	


func _on_enet_host_pressed() -> void:
	enet_host.emit()


func _on_enet_join_pressed() -> void:
	enet_join.emit()

# Easy quit implementation for debug purposes
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_steam_host_pressed() -> void:
	steam_host.emit()


func _on_steam_list_lobbies_pressed() -> void:
	steam_list_lobbies.emit()
