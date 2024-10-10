extends Node

class_name StateMachine

# State machine for managing states

var states : Dictionary = {}
var current_state : State
@export var initial_state : State

signal change_state()

# NOTE General state machine

func _ready():
    for child in get_children():
        if child is State:
            states[child.name.to_lower()] = child
            child.state_transition.connect(change_state)

    if initial_state:
        initial_state.Enter()
        current_state = initial_state
