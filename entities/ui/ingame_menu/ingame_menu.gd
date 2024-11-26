extends Control

signal continue_pressed()
signal leave_pressed()

func _on_continue_pressed() -> void:
	continue_pressed.emit()


func _on_leave_pressed() -> void:
	leave_pressed.emit()
