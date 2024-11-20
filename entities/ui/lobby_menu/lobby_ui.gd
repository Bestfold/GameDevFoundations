extends VBoxContainer

@onready var network_manager: Node = %NetworkManager
@onready var lobby_container: VBoxContainer = %LobbyContainer
@onready var steam_tab: Control = %Steam
@onready var enet_tab: Control = %ENet
@onready var tab_container: TabContainer = %TabContainer


#signal game_log(message: String)

signal enet_host_pressed()
signal enet_join_pressed()
signal steam_host_pressed()
signal steam_list_lobbies_pressed()
#signal steam_join()
signal back_pressed()

signal enet_tab_chosen()
signal steam_tab_chosen()


func _ready():
	pass
	


func _on_enet_host_pressed() -> void:
	enet_host_pressed.emit()


func _on_enet_join_pressed() -> void:
	enet_join_pressed.emit()


func _on_steam_host_pressed() -> void:
	steam_host_pressed.emit()


func _on_steam_list_lobbies_pressed() -> void:
	steam_list_lobbies_pressed.emit()


func _on_back_pressed() -> void:
	back_pressed.emit()


func _on_tab_container_tab_changed(_tab: int) -> void:
	var tab_title = tab_container.get_tab_title(_tab)

	if tab_title == enet_tab.name: # enet_tab
		enet_tab_chosen.emit()
	elif tab_title == steam_tab.name: # steam_tab
		steam_tab_chosen.emit()
