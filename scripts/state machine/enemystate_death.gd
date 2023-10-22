class_name EnemyDeathState
extends FSMState

@export var character_body : CharacterBody3D
@export var death_package : PackedScene

func enter_state():
	super.enter_state()
	if death_package:
		var obj = death_package.instantiate()
		obj.position = character_body.global_position
		obj.basis = character_body.basis
		get_tree().root.add_child(obj)
		
	character_body.queue_free()
	
