class_name FSMState
extends Node

signal stateComplete

func _ready():
	set_physics_process(false)
	set_process(false)

func enter_state() -> void:
	set_physics_process(true)
	set_process(true)

func exit_state() -> void:
	set_physics_process(false)
	set_process(false)

