class_name EnemyChaseState
extends FSMState

@export var player_sensor : PlayerSensor
@export var nav_agent : NavigationAgent3D
@export var character_body : CharacterBody3D

@export var attack_range : float = 2.0
@export var chase_speed : float = 1.5
@export var rotation_speed : float = 120.0
@export var chase_max_time : float = 1.5
var attacking : bool = false
var chase_timer : float = 0.0
var timer : Timer

func _ready():
	super._ready()
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true

func _physics_process(delta):
	if not attacking:
		chase_timer -= delta
		if nav_agent.is_navigation_finished() or chase_timer <= 0.0:
			stateComplete.emit()
			return
		
		var nextPoint : Vector3 = nav_agent.get_next_path_position()
		var direction : Vector3 = (nextPoint - character_body.global_position).normalized() * chase_speed
		direction += Vector3.DOWN * 9.81
		character_body.velocity = direction
		character_body.rotation.y = lerp_angle(character_body.rotation.y, atan2(direction.x, direction.z), delta * deg_to_rad(rotation_speed))
		character_body.move_and_slide()
	else:
		var direction : Vector3 = (player_sensor.get_player_position() - character_body.global_position).normalized()
		character_body.rotation.y = lerp_angle(character_body.rotation.y, atan2(direction.x, direction.z), delta * deg_to_rad(rotation_speed* 2.0))

func enter_state():
	super.enter_state()
	attacking = false
	
	if player_sensor.get_player_distance() < attack_range:
		attacking = true
		timer.wait_time = 1.5
		timer.start()
		await timer.timeout
		stateComplete.emit()
	else:
		chase_timer = randf_range(chase_max_time * 0.5, chase_max_time)
		nav_agent.set_target_position(player_sensor.get_player_position())

func exit_state():
	super.exit_state()
	timer.stop()
#check range to player (senses reference)
#if we are close (within range of an attack), play an attack animation, wait, singal completion
#if we are not close, path to a spot near the player, wait 0.5-1 seconds, signal completion
