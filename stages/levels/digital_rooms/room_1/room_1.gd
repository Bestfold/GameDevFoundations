extends DigitalRoomInterface
class_name Room1

@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner


func _ready():
	multiplayer_spawner.spawn_limit = SteamManager.lobby_max_members
	print(player_spawn_node.name)
