extends Node
class_name GameManager

@onready var singleplayer_player: Player = $Player
@onready var multiplayer_players: Node3D = $MultiplayerPlayers


@onready var debug_ui: DebugUI = %DebugUI
@onready var lobby_screen: VBoxContainer = %LobbyScreen


func _ready():
	lobby_screen.hide()
	debug_ui.hide()
	
	# Connecting to adding or removing players from autoload
	if !MultiplayerManager.player_list_changed.is_connected(amount_of_players_changed):
		MultiplayerManager.player_list_changed.connect(amount_of_players_changed)


	# Debug signals for monitoring values on screen
	#ui._update_var1_label()
	if !singleplayer_player.var_monitoring_1.is_connected(debug_ui._monitored_value_1):
		singleplayer_player.var_monitoring_1.connect(debug_ui._monitored_value_1)

	if !singleplayer_player.var_monitoring_2.is_connected(debug_ui._monitored_value_2):
		singleplayer_player.var_monitoring_2.connect(debug_ui._monitored_value_2)

	#if !singleplayer_player.var_monitoring_3.is_connected(ui._monitored_value_3):
	#	singleplayer_player.var_monitoring_3.connect(ui._monitored_value_3)

	#if !singleplayer_player.var_monitoring_4.is_connected(ui._monitored_value_4):
	#	singleplayer_player.var_monitoring_4.connect(ui._monitored_value_4)

	#if !singleplayer_player.var_monitoring_5.is_connected(ui._monitored_value_5):
	#	singleplayer_player.var_monitoring_5.connect(ui._monitored_value_5)

func amount_of_players_changed():
	print("Signal kom gjennom")
	
# Escape-menu for game-instance
func _input(_event):
	if Input.is_action_just_pressed("escape"):
		if lobby_screen.visible:
			lobby_screen.hide()
			toggle_menu_control_at_player(false)
		else:
			lobby_screen.show()
			toggle_menu_control_at_player(true)

# Changes menu_visible atribute at either single- or multiplayer-player, which again determines wether
#  look_component.capture_mouse captures or free's mouse
#		Could be changed to a signal, which players connect to, but in order to
#		 keep player without refrence to game, this is done:
func toggle_menu_control_at_player(value: bool):
	if singleplayer_player != null:
		singleplayer_player.menu_visible = value
		singleplayer_player.look_component.capture_mouse()
		
	var id = multiplayer.get_unique_id()
	if multiplayer_players.has_node(str(id)):
		var multiplayer_player = multiplayer_players.get_node(str(id))
		multiplayer_player.menu_visible = value
		multiplayer_player.look_component.capture_mouse()
