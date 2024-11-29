extends PlayerCharacter

class_name PlayerSingleplayer


# Debug signals -> values to screen
signal var_monitoring_1(value_to_monitor)
signal var_monitoring_2(value_to_monitor)
#signal var_monitoring_3(value_to_monitor)
#signal var_monitoring_4(value_to_monitor)
#signal var_monitoring_5(value_to_monitor)

# Player is controlled by state-children, as exception to common standard.

const player_id = 0


func _ready() -> void:
	# Initialize state machine, passing a refrence of player to the states
	state_machine.init(self, animation_tree, skeleton, move_component, 
			look_component,	can_interact_component)

	look_component.capture_mouse()

	# Sets head invisible for player
	head_mesh.visible = false
	
	

func _unhandled_input(event: InputEvent) -> void:
	# Passes _unhandled_input() to state machine
	state_machine.process_input(event)


func _physics_process(delta: float) -> void:
	#var animation_state_machine = animation_tree["parameters/playback"]
	#print(animation_state_machine.get_current_node())
	# Passing function
	state_machine.process_physics(delta)

	# Monitoring
	#var_monitoring.emit(animation_tree.get("parameters/BlendSpace1D/blend_position"))
	if look_component is LookPlayer:
		var_monitoring_1.emit(look_component.head_bobbing_vector)
		var_monitoring_2.emit(head_bobbing.position)

# Passing function
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
