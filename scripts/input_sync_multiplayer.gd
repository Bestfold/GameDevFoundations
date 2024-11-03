extends MultiplayerSynchronizer

@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer
@onready var player: CharacterBody3D = $".."

var input_dir := Vector2(0,0)
var do_jump := false
var do_run := false

# Handles input on relevant client, and replicates to others.
# Should have replication authority
func _ready():
	# Does nothing if not the right client
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)
		set_process_unhandled_input(false)

	input_dir = Input.get_vector("left", "right", "forward", "back")


func _physics_process(_delta):
	input_dir = Input.get_vector("left", "right", "forward", "back")

func _process(_delta):
		if Input.is_action_just_pressed("jump"):
			do_jump = true

		elif Input.is_action_just_pressed("run"):
			do_run = true
