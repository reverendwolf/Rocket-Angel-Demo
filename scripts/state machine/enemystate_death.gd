class_name EnemyDeathState
extends FSMState

@export var character_body : CharacterBody3D
@export var death_package : PackedScene
@export var animTree : AnimationTree
var anim_state

func _ready():
	super._ready()
	

func enter_state():
	super.enter_state()
	anim_state = animTree["parameters/playback"]
	anim_state.travel("Death")
	await animTree.animation_finished
	await get_tree().create_timer(1.0).timeout
	if death_package:
		var obj = death_package.instantiate()
		obj.position = character_body.global_position
		obj.basis = character_body.basis
		get_tree().root.add_child(obj)
		
	character_body.queue_free()
	
