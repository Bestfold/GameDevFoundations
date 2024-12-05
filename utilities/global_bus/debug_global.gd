extends Node

var debug_ui

var var1:
	set(value):
		var1 = value
		debug_ui.var1 = var1

var var2:
	set(value):
		var2 = value
		debug_ui.var2 = var2

var var3:
	set(value):
		var3 = value
		debug_ui.var3 = var3

var var4:
	set(value):
		var4 = value
		debug_ui.var4 = var4

var var5:
	set(value):
		var5 = value
		debug_ui.var5 = var5


func _ready():
	debug_ui = get_tree().get_current_scene().get_node("UI/DebugUI")
