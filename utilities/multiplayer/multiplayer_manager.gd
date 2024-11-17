extends Node
#class_name MultiplayerManager

## Global "autoload" keeping track of multiplayer states

# PlayerSpawner's target spawn-under-node
var multiplayer_mode_enabled: bool = false:
    set(value):
        multiplayer_mode_enabled = value
        multiplayer_enabled.emit(value)

var host_mode_enabled: bool = false
var join_mode_enabled: bool = false
# Midlertidig spawn point
var respawn_point = Vector3(0,0,0)

signal multiplayer_enabled(value)