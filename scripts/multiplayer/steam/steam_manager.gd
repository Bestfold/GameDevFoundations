extends Node

## Autoload


var is_owned: bool = false
var steam_app_id: int = 480 # Testing game app ID
var steam_id: int = 0
var steam_username: String = ""

var lobby_id: int = 0
var lobby_max_members: int = 4

var steam_initialized = false

# Debug logger
#signal steam_manager_log(value)

func _init():
	print("Init Steam")
	# Environment variables of OS
	OS.set_environment("SteamAppId", str(steam_app_id))
	OS.set_environment("SteamGameId", str(steam_app_id))

func _process(_delta):
	Steam.run_callbacks()

func initialize_steam():
	if steam_initialized:
		print("Steam already initialized")
		return

	# Initializing the Steam API connection (?)
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Steam init response: %s " % initialize_response)

	if initialize_response['status'] > 0:
		print("Failed to initialize Steam! Shitting down. %s " % initialize_response)
		get_tree().quit()
	
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()

	print("steam_id is: %s ", steam_id)

	# Checks if the steam user owns the game, and ends if not owned
	#if is_owned == false:
	#    print("User does not own the game")
	#    get_tree().quit()


	steam_initialized = true
