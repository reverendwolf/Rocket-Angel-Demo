class_name EnemyPainState
extends FSMState

@export var player_sensor : PlayerSensor
@export_range(0,5) var pain_chance : int = 1

func enter_state():
	super.enter_state()
	if randi_range(1, 5) <= pain_chance:
		await get_tree().create_timer(1).timeout
		
	player_sensor.force_player_reference()
	stateComplete.emit()
