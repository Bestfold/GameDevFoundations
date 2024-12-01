extends Node

# Manages menu-control

var game
var digital_rooms_manager
var ui
var multiplayer_players
var singleplayer_player


var in_game: bool = false
var instances_player_on_computer = false



func _ready():
	game = get_tree().get_current_scene().get_node(".")
	print(game)
	digital_rooms_manager = game.get_node("DigitalRoomsManager")
	ui = game.get_node("UI")


func _input(_event):
		# Debug window for values
	if Input.is_action_just_pressed("debug"):
		if ui.debug_ui.visible:
			ui.debug_ui.hide()
		else:
			ui.debug_ui.show()

	
	if not in_game || instances_player_on_computer:
		return

	# Escape-menu for game-instance
	if Input.is_action_just_pressed("escape"):
		#print(digital_rooms_manager)
		#print(ui)
		if not ui.ingame_menu.visible:
			ui.toggle_ingame_menu(true)
			toggle_menu_control_at_player(true)
		else:
			ui.toggle_ingame_menu(false)
			toggle_menu_control_at_player(false)
	


# Changes menu_visible atribute at either single- or multiplayer-player, which again determines wether
#  look_component.capture_mouse captures or free's mouse
#		Could be changed to a signal, which players connect to, but in order to
#		 keep player without refrence to game, this is done:

func toggle_menu_control_at_player(value: bool):
	if MultiplayerManager.multiplayer_mode_enabled:
		multiplayer_players = game.get_node("MultiplayerPlayers")
		var id = multiplayer.get_unique_id()
		
		if multiplayer_players.has_node(str(id)):
			var multiplayer_player = multiplayer_players.get_node(str(id))
			multiplayer_player.toggle_menu_control(value)
		else:
			push_error("MenuManager:toggle_menu_control_at_player: MultiplayerPlayer OF ID: " + str(id) + " NOT FOUND")	
	else:
		singleplayer_player = game.get_node("PlayerSingleplayer")
		if singleplayer_player != null:
			singleplayer_player.toggle_menu_control(value)
		else:
			push_error("MenuManager:toggle_menu_control_at_player: SingleplayerPlayer NOT FOUND")
