extends FSMState

@export var character_body : CharacterBody3D
@export var player_sensor : PlayerSensor
@export var anim_tree : AnimationTree
@export var shoot_point : Node3D
@export var rotation_speed : float = 180.0
@export var projectile : PackedScene

var shot_cooldown : float = 1.0
var anim_state

func enter_state():
	super.enter_state()
	shot_cooldown = 0.5
	anim_state = anim_tree["parameters/playback"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shot_cooldown > 0.0:
		shot_cooldown -= delta
	
	if shot_cooldown <= 0.0:
		shoot()

func shoot():
	anim_state.travel("Ranged")
	shot_cooldown = randf_range(0.8, 1.5)
	
func fire_projectile(): 
	var proj_force : float
	var gauss_x : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
	var gauss_z : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
	var gauss_f : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
	if player_sensor.player_seen:
		shoot_point.look_at(player_sensor.get_player_position() + (Vector3.UP * 3) + (Vector3(gauss_x,0.0,gauss_z) * 4.0))
		proj_force = player_sensor.get_player_distance() + gauss_f
	else:
		shoot_point.look_at(character_body.global_position + (character_body.basis.z * 5.0) + (Vector3.UP * 5) + (Vector3(gauss_x,0.0,gauss_z) * 2.0))
		proj_force = randf_range(6.0,12.0)
		
	var obj = projectile.instantiate() as Bugshot
	get_tree().get_first_node_in_group("CurrentScene").add_child(obj)
	#await get_tree().process_frame
	obj.global_position = shoot_point.global_position
	obj.global_rotation = shoot_point.global_rotation
	obj.assign_owner(character_body)
	obj.set_axis_velocity(-obj.basis.z * proj_force)

func _physics_process(delta):
	var direction : Vector3 = (player_sensor.get_player_position() - character_body.global_position).normalized()
	character_body.rotation.y = lerp_angle(character_body.rotation.y, atan2(direction.x, direction.z), delta * deg_to_rad(rotation_speed* 2.0))
	pass
