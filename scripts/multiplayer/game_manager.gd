extends Node
class_name GameManager

@onready var singleplayer_player: Player = $Player
@onready var multiplayer_players: Node3D = $MultiplayerPlayers

@onready var debug_ui: DebugUI = %DebugUI
@onready var lobby_screen: VBoxContainer = %LobbyScreen


func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server")
		%NetworkManager.become_host(true)

	lobby_screen.hide()
	debug_ui.hide()
	
	lobby_screen.enet_host.connect(become_host)
	lobby_screen.enet_join.connect(join_as_client)
	
	lobby_screen.steam_host.connect(use_steam)
	lobby_screen.steam_host.connect(become_host)
	
	lobby_screen.steam_list_lobbies.connect(use_steam)
	lobby_screen.steam_list_lobbies.connect(list_steam_lobbies)

	#lobby_screen.steam_join.connect(join_as_client)
	#lobby_screen.steam_join.connect(use_steam)


func become_host():
	print("Host game")
	_remove_single_player()
	%NetworkManager.become_host()


func join_as_client():
	print("Join game")
	join_lobby()


func list_steam_lobbies():
	print("List lobbies")
	%NetworkManager.list_lobbies()


func join_lobby(lobby_id: int = 0):
	print("Joining lobby %s" % lobby_id)
	_remove_single_player()
	%NetworkManager.join_as_client(lobby_id)

# Initialization and running config for steam multiplayer
func use_steam():
	print("Using Steam")
	SteamManager.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	%NetworkManager.active_network_type = %NetworkManager.MULTIPLAYER_NETWORK_TYPE.STEAM

# Handles returned lobbies from Steam. Adds joinable lobbies in lobby list GUI
func _on_lobby_match_list(lobbies: Array):
	print("On lobby match list")

	# Removes all exisiting lobbies from list
	for lobby_child in lobby_screen.lobby_container.get_children():
		lobby_child.queue_free()

	# Checks if returned lobbies pass filter, and adds button with connection to lobby
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")

		if lobby_name != "": #&& lobby_name == "ABEKADD":
			var lobby_mode: String = Steam.getLobbyData(lobby, "mode")

			var lobby_button: Button = Button.new()
			lobby_button.set_text(lobby_name + " | " + lobby_mode)
			lobby_button.set_size(Vector2(100, 30))
			lobby_button.add_theme_font_size_override("font_size", 8)

			# Custom font
			#var fv = FontVariation.new()
			#fv.set_base_font(load("filepath"))
			#lobby_button.add_theme_font_override("font", fv)

			lobby_button.set_name("lobby_%s" % lobby)
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT

			# Signal definition. "pressed" signal, set ut Callable to define what function of self, and bind argument to the call (lobby)
			lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))

			lobby_screen.lobby_container.add_child(lobby_button)


	# 	Avslutta her 10.11.24: Battery Acid Dev's Godot + Steam P2P Multiplayer Tutorial video - 40:00
	
# Removes single player controller
func _remove_single_player():
	if has_node("Player"):
		var player_to_remove = get_tree().get_current_scene().get_node("Player")
		player_to_remove.queue_free()
	




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
