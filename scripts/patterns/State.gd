class_name State
extends Node

signal OnEnter()
signal OnExit()


func _ready() -> void:
	initialize()
	
	
var state_machine : StateMachine = null:
	set(value):
		state_machine = value

#viertual function called once the state machine is in set
func initialize():
	pass

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	print(state_machine.name, " entered state ", name)
	emit_signal("OnEnter")

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	emit_signal("OnExit")
