extends Control

signal singleplayer_pressed()

signal multiplayer_pressed()

func _ready():
	pass

func _on_singeplayer_pressed() -> void:
	singleplayer_pressed.emit()


func _on_multiplayer_pressed() -> void:
	multiplayer_pressed.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
