extends Node

@export var idleState : FSMState
@export var activeState : FSMState
@export var painState : FSMState
@export var deathState : FSMState

@onready var fsm : FSM = $FSM as FSM
@onready var senses : PlayerSensor = $Senses as PlayerSensor
@onready var health : Health = $Health as Health

func _ready():
	plug_in()
	pass

func plug_in():
	idleState.stateComplete.connect(fsm.change_state.bind(idleState))
	senses.PlayerSeen.connect(fsm.change_state.bind(activeState))
	senses.PlayerLost.connect(fsm.change_state.bind(idleState))
	activeState.stateComplete.connect(fsm.change_state.bind(activeState))
	painState.stateComplete.connect(fsm.change_state.bind(activeState))
	
func plug_out():
	idleState.stateComplete.disconnect(fsm.change_state.bind(idleState))
	senses.PlayerSeen.disconnect(fsm.change_state.bind(activeState))
	senses.PlayerLost.disconnect(fsm.change_state.bind(idleState))
	activeState.stateComplete.disconnect(fsm.change_state.bind(activeState))
	painState.stateComplete.disconnect(fsm.change_state.bind(activeState))
	
func damage_taken():
	fsm.change_state(painState)

func health_depleted():
	plug_out()
	fsm.change_state(deathState)
