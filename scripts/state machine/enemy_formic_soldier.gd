extends Node

@onready var fsm : FSM = $FSM as FSM
@onready var wanderState : EnemyWanderState = $FSM/EnemyWanderState as EnemyWanderState
@onready var chaseState : EnemyChaseState = $FSM/EnemyChaseState as EnemyChaseState
@onready var senses : PlayerSensor = $Senses as PlayerSensor

func _ready():
	wanderState.stateComplete.connect(fsm.change_state.bind(wanderState))
	senses.PlayerSeen.connect(fsm.change_state.bind(chaseState))
