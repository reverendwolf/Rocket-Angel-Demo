class_name EnemyPainState
extends FSMState

@export var player_sensor : PlayerSensor

func enter_state():
	super.enter_state()
	print("Ouch!")
	await get_tree().create_timer(1).timeout
	player_sensor.force_player_reference()
	stateComplete.emit()
