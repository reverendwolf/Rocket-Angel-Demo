class_name EnemyPainState
extends FSMState

@export var player_sensor : PlayerSensor
@export_range(0,5) var pain_chance : int = 1
@export var animTree : AnimationTree
var anim_state

func _ready():
	super._ready()
	

func enter_state():
	super.enter_state()
	anim_state = animTree["parameters/playback"]
	if randi_range(1, 5) <= pain_chance:
		anim_state.travel("Pain")
		await animTree.animation_finished
	else:
		await get_tree().process_frame
		
	player_sensor.force_player_reference()
	stateComplete.emit()
