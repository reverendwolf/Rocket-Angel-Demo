class_name FSM
extends Node

@export var current_state : FSMState

func _ready():
	call_deferred("initialize_state")
		
func initialize_state():
	if current_state:
		change_state(current_state)
	else:
		print("No starting stage")

func change_state(new_state : FSMState):
	if current_state is FSMState:
		current_state.exit_state()
		
	new_state.enter_state()
	current_state = new_state
