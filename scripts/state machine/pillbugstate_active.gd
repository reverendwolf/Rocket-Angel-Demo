extends FSMState

@export var character_body : CharacterBody3D
@export var player_sensor : PlayerSensor
@export var shoot_point : Node3D
@export var rotation_speed : float = 180.0
@export var projectile : PackedScene

var shot_cooldown : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.

func enter_state():
	super.enter_state()
	shot_cooldown = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shot_cooldown > 0.0:
		shot_cooldown -= delta
	
	if shot_cooldown <= 0.0:
		shoot()

func shoot():
	shot_cooldown = randf_range(0.8, 1.5)
	var gauss_x : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
	var gauss_z : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
	shoot_point.look_at(player_sensor.get_player_position() + Vector3.UP + (Vector3(gauss_x,0.0,gauss_z) * 3.0))
	
	var obj = projectile.instantiate() as Projectile
	obj.assign_owner(character_body)
	obj.position = shoot_point.global_position
	obj.basis = shoot_point.global_transform.basis
	get_tree().get_first_node_in_group("CurrentScene").add_child.call_deferred(obj)
	
func _physics_process(delta):
	var direction : Vector3 = (player_sensor.get_player_position() - character_body.global_position).normalized()
	character_body.rotation.y = lerp_angle(character_body.rotation.y, atan2(direction.x, direction.z), delta * deg_to_rad(rotation_speed* 2.0))
	pass
