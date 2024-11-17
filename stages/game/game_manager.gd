extends Node
class_name GameManager

@onready var multiplayer_players: Node3D = $MultiplayerPlayers
@onready var ui: CanvasLayer = %UI

@export var world_scene: PackedScene
@export var singleplayer_player_scene: PackedScene


# Debug logger
#signal game_log(value)

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server")
		%NetworkManager.become_host(true)
	
	ui.main_menu.singleplayer_chosen.connect(start_singleplayer)
	
	ui.lobby_menu.enet_host.connect(become_host)
	ui.lobby_menu.enet_join.connect(join_as_client)
	
	ui.lobby_menu.steam_host.connect(use_steam)
	ui.lobby_menu.steam_host.connect(become_host)
	
	ui.lobby_menu.steam_list_lobbies.connect(use_steam)
	ui.lobby_menu.steam_list_lobbies.connect(list_steam_lobbies)
	

	#lobby_menu.steam_join.connect(join_as_client)
	#lobby_menu.steam_join.connect(use_steam)

func start_singleplayer():
	_add_world()

	preload("res://entities/characters/player_characters/singleplayer_player/singleplayer_player.tscn")
	var singleplayer_player = singleplayer_player_scene.instantiate()
	add_child(singleplayer_player)

func start_multiplayer():
	_add_world()

func _add_world():
	preload("res://stages/levels/world/world.tscn")
	var world = world_scene.instantiate()
	add_child(world)
	move_child(world, 1)

func become_host():
	print("Host game")
	start_multiplayer()
	_remove_single_player()
	%NetworkManager.become_host()


func join_as_client():
	print("Join game")
	join_lobby()


func list_steam_lobbies():
	print("List lobbies")
	%NetworkManager.list_lobbies()


func join_lobby(lobby_id: int = 0):
	start_multiplayer()
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
	for lobby_child in ui.lobby_menu.lobby_container.get_children():
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

			ui.lobby_menu.lobby_container.add_child(lobby_button)


	# 	Avslutta her 10.11.24: Battery Acid Dev's Godot + Steam P2P Multiplayer Tutorial video - 40:00
	
# Removes single player controller
func _remove_single_player():
	if has_node("PlayerSingleplayer"):
		var player_to_remove = get_tree().get_current_scene().get_node("PlayerSingleplayer")
		player_to_remove.queue_free()
	





func _input(_event):
	# Escape-menu for game-instance
	if Input.is_action_just_pressed("escape"):
		if ui.lobby_menu.visible:
			ui.lobby_menu.hide()
			#toggle_menu_control_at_player(false)
		else:
			ui.lobby_menu.show()
			#toggle_menu_control_at_player(true)
	
	# Debug window for values
	if Input.is_action_just_pressed("debug"):
		if ui.debug_ui.visible:
			ui.debug_ui.hide()
		else:
			ui.debug_ui.show()

# Changes menu_visible atribute at either single- or multiplayer-player, which again determines wether
#  look_component.capture_mouse captures or free's mouse
#		Could be changed to a signal, which players connect to, but in order to
#		 keep player without refrence to game, this is done:

#func toggle_menu_control_at_player(value: bool):
#	if singleplayer_player != null:
#		singleplayer_player.menu_visible = value
#		singleplayer_player.look_component.capture_mouse()
		
#	var id = multiplayer.get_unique_id()
#	if multiplayer_players.has_node(str(id)):
#		var multiplayer_player = multiplayer_players.get_node(str(id))
#		multiplayer_player.menu_visible = value
#		multiplayer_player.look_component.capture_mouse()
