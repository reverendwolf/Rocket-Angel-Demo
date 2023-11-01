extends FSMState

@export var character_body : CharacterBody3D
@export var rotation_speed : float = 90
@export var shoot_point : Node3D
@export var projectile : PackedScene

var random_direction : Vector3
var shot_cooldown : float
var timer : Timer

func _ready():
	super._ready()
	timer = Timer.new()
	add_child(timer)

func enter_state():
	super.enter_state()
	random_direction = Vector3((randf() - 0.5) * 2, 0.0, (randf() - 0.5 * 2))
	timer.wait_time = randf_range(4.0, 6.5)
	timer.start()
	await timer.timeout
	stateComplete.emit()
	
func exit_state():
	super.exit_state()
	timer.stop()

func _process(delta):
	if shot_cooldown > 0.0:
		shot_cooldown -= delta
	
	if shot_cooldown <= 0.0:
		shoot()
	pass

func _physics_process(delta):
	character_body.rotation.y = lerp_angle(character_body.rotation.y, atan2(random_direction.x, random_direction.z), delta * deg_to_rad(120))
	pass

func shoot():
	shot_cooldown = randf_range(2.5, 4.5)
	
	var gauss_x : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5) * 3.0
	var gauss_y : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5) + 1.5
	var gauss_z : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5) * 3.0

	shoot_point.look_at(character_body.global_position + (character_body.transform.basis.z * 5) + Vector3(gauss_x, gauss_y, gauss_z))
	
	var obj = projectile.instantiate() as Projectile
	obj.assign_owner(character_body)
	get_tree().get_first_node_in_group("CurrentScene").add_child(obj)
	obj.position = shoot_point.global_position
	obj.global_rotation = shoot_point.global_rotation
	
