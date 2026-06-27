# ==============================================================================
# SINGLE SOURCE OF TRUTH: Finite State Machine (FSM) for Godot 4.x
# ==============================================================================
# Usage:
# 1. Attach this script to a Node named "StateMachine" inside the target entity.
# 2. Add child nodes to StateMachine representing states (e.g. Idle, Walk, Attack).
# 3. Each child node should extend State.
# ==============================================================================
extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# Add all children states to dictionary
	for child in get_children():
		if child is State:
			states[child.name.lower()] = child
			child.state_transition.connect(change_state)

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(source_state: State, new_state_name: String) -> void:
	if source_state != current_state:
		return
		
	var new_state: State = states.get(new_state_name.lower())
	if !new_state:
		print("FSM Warning: State not found: ", new_state_name)
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state

# ==============================================================================
# BASE CLASS: State (Put this in a separate file or keep as inner class)
# ==============================================================================
# Place the class below in "state.gd" or inherit directly:
# ==============================================================================
# extends Node
# class_name State
#
# signal state_transition(source_state: State, new_state_name: String)
#
# func enter() -> void:
#	pass
#
# func exit() -> void:
#	pass
#
# func update(delta: float) -> void:
#	pass
#
# func physics_update(delta: float) -> void:
#	pass
# ==============================================================================
