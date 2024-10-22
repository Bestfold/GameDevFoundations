extends Node
class_name Game

@onready var player: Player = $Player

@onready var ui: UI = $UI


func _ready():
	# Debug signals for monitoring values on screen
	#ui._update_var1_label()
	if !player.var_monitoring_1.is_connected(ui._monitored_value_1):
		player.var_monitoring_1.connect(ui._monitored_value_1)

	if !player.var_monitoring_2.is_connected(ui._monitored_value_2):
		player.var_monitoring_2.connect(ui._monitored_value_2)

	#if !player.var_monitoring_3.is_connected(ui._monitored_value_3):
	#	player.var_monitoring_3.connect(ui._monitored_value_3)

	#if !player.var_monitoring_4.is_connected(ui._monitored_value_4):
	#	player.var_monitoring_4.connect(ui._monitored_value_4)

	#if !player.var_monitoring_5.is_connected(ui._monitored_value_5):
	#	player.var_monitoring_5.connect(ui._monitored_value_5)
