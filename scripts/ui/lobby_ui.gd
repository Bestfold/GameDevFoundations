extends VBoxContainer



#signal game_log(message: String)

signal e_net_host()
signal e_net_join()
#signal steamHost()
#signal steamJoin()


func _ready():
	pass
	


func _on_e_net_host_pressed() -> void:
	e_net_host.emit()


func _on_e_net_join_pressed() -> void:
	e_net_join.emit()

# Easy quit implementation for debug purposes
func _on_quit_pressed() -> void:
	get_tree().quit()
