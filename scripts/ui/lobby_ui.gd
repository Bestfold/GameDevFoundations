extends VBoxContainer



#signal game_log(message: String)

signal e_net_host()
signal e_net_join()
signal steam_host()
signal steam_list_lobbies()
#signal steam_join()


func _ready():
	pass
	


func _on_e_net_host_pressed() -> void:
	e_net_host.emit()


func _on_e_net_join_pressed() -> void:
	e_net_join.emit()

# Easy quit implementation for debug purposes
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_steam_host_pressed() -> void:
	steam_host.emit()


func _on_steam_list_lobbies_pressed() -> void:
	steam_list_lobbies.emit()
