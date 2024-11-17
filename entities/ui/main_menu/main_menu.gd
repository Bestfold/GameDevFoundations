extends Control

signal singleplayer_chosen()

signal multiplayer_chosen()

func _ready():
	pass

func _on_singeplayer_pressed() -> void:
	singleplayer_chosen.emit()


func _on_multiplayer_pressed() -> void:
	multiplayer_chosen.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
