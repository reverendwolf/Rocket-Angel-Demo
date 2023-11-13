class_name EnemyChaseState
extends FSMState

@export var player_sensor : PlayerSensor
@export var nav_agent : NavigationAgent3D
@export var character_body : CharacterBody3D
@export var animTree : AnimationTree

@export var attack_range : float = 2.0
@export var chase_speed : float = 1.5
@export var rotation_speed : float = 120.0
@export var chase_max_time : float = 1.5
var attacking : bool = false
var chase_timer : float = 0.0
var timer : Timer

@export var melee_point : Node3D
@export var shoot_point : Node3D
@export var melee_projectile : PackedScene
@export var ranged_projectile : PackedScene

var anim_state

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
	anim_state = animTree["parameters/playback"]
	animTree.set("parameters/Loco/blend_position", 1)
	#if in attack range, melee
	#else, choose between advancing or shooting
	
	if player_sensor.get_player_distance() < attack_range:
		attacking = true
		anim_state.travel("Melee")
		await animTree.animation_finished
		stateComplete.emit()
	else:
		if randf() <= 0.25:
			attacking = true
			anim_state.travel("Ranged")
			await animTree.animation_finished
			stateComplete.emit()
		else:
			chase_timer = randf_range(chase_max_time * 0.5, chase_max_time)
			nav_agent.set_target_position(player_sensor.get_player_position())

func exit_state():
	super.exit_state()
	timer.stop()
	animTree.set("parameters/Loco/blend_position", 0)
#check range to player (senses reference)
#if we are close (within range of an attack), play an attack animation, wait, singal completion
#if we are not close, path to a spot near the player, wait 0.5-1 seconds, signal completion

func melee_attack():
	var obj = melee_projectile.instantiate() as Projectile
	get_tree().root.add_child(obj)
	obj.position = melee_point.global_position
	obj.global_rotation = melee_point.global_rotation
	obj.assign_owner(character_body)
	
	

func ranged_attack():
	var gauss_x = (randf() + randf() - 1) * 3.0
	var gauss_z = (randf() + randf() - 1) * 3.0
	shoot_point.look_at(player_sensor.get_player_position() + Vector3(gauss_x, 1, gauss_z))
	var obj = ranged_projectile.instantiate() as Bugshot
	get_tree().get_first_node_in_group("CurrentScene").add_child(obj)
	obj.global_position = shoot_point.global_position
	obj.global_rotation = shoot_point.global_rotation
	obj.assign_owner(character_body)
	obj.set_axis_velocity(-obj.basis.z * randf_range(-0.5,2.0) * player_sensor.get_player_distance())
