class_name EnemyWanderState
extends FSMState

@export var character_body : CharacterBody3D
@export var navAgent : NavigationAgent3D
@export var animTree : AnimationTree
@export var rotation_speed : float = 120.0
@export var movement_speed : float = 3.5
@export var wander_distance : float = 8.0

var timer : Timer

var startPosition : Vector3

var first_frame_wait : bool = true

@export var barker : AudioStreamPlayer3D

func _ready():
	super._ready()
	startPosition = character_body.global_position
	timer = Timer.new()
	add_child(timer)

func enter_state():
	super.enter_state()
	if randf() < 0.65:
		barker.pitch_scale = randf_range(0.8, 1.2)
		barker.play(0.0)
		
	animTree.set("parameters/Loco/blend_position", 0.5)
	
	var randomDir : Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(0, wander_distance)
	navAgent.set_target_position(startPosition + \
	Vector3(randomDir.x, character_body.global_position.y, randomDir.y))
	
	timer.wait_time = randf_range(3.5, 7.5)
	timer.start()
	await timer.timeout
	stateComplete.emit()
	
func exit_state():
	super.exit_state()
	animTree.set("parameters/Loco/blend_position", 0)
	timer.stop()

func _physics_process(delta):
	if first_frame_wait:
		first_frame_wait = false
		return
	
	if navAgent.is_node_ready() and navAgent.is_navigation_finished():
		animTree.set("parameters/Loco/blend_position", 0)
		return
	
	var nextPoint : Vector3 = navAgent.get_next_path_position()
	var direction : Vector3 = (nextPoint - character_body.global_position).normalized() * movement_speed
	direction += Vector3.DOWN * 9.81
	character_body.velocity = direction
	character_body.rotation.y = lerp_angle(character_body.rotation.y, atan2(direction.x, direction.z), delta * deg_to_rad(rotation_speed))
	character_body.move_and_slide()
