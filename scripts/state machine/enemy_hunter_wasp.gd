extends CharacterBody3D

enum WaspState
{
	IDLE,
	ACTIVE
}

@export var float_speed : float = 3.5

var state : WaspState
var targetDirection : Vector3
var targetFacing : Vector3
var timer : Timer
var startPosition : Vector3

var accumulator : float

var shot_cooldown : float
var total_shots : int

@export var projectile : PackedScene
@export var shootPoint : Node3D
@onready var player_sensor : PlayerSensor = $Senses as PlayerSensor

@export var death_package : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	startPosition = global_position
	state = WaspState.IDLE
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(update_behavior)
	update_behavior()

func _on_health_depleted():
	spawn_death()
	queue_free()

func reset_timer(time : float):
	timer.wait_time = time
	timer.start()

func spawn_death():
	var obj = death_package.instantiate()
	get_tree().get_first_node_in_group("CurrentScene").add_child(obj)
	obj.global_position = global_position
	obj.global_rotation = global_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shot_cooldown = clamp(shot_cooldown - delta, 0.0, 2.0)
	
	accumulator += delta
	if accumulator > 10.0:
		accumulator = -10.0
	
	if state == WaspState.ACTIVE:
		targetFacing = global_position.direction_to(player_sensor.get_player_position())
		#shootPoint.look_at(player_sensor.get_player_position() + Vector3(sin(accumulator) * 2.0, cos(accumulator + 0.2) * 2.0, sin(accumulator + 0.4) * 2.0))
		if shot_cooldown <=0 :
			shoot()
		
	pass
	
func shoot():
	total_shots = (total_shots + 1) % 3
	if total_shots > 0:
		shot_cooldown = randf_range(0.25, 0.45)
	else:
		shot_cooldown = randf_range(1.25, 2.0)
	
	var gauss_x : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
	var gauss_y : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
	var gauss_z : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)

	shootPoint.look_at(player_sensor.get_player_position() + Vector3(gauss_x,gauss_y,gauss_z) * (player_sensor.get_player_distance() * 0.5))
	var obj = projectile.instantiate() as Projectile
	obj.assign_owner(self)
	obj.position = shootPoint.global_position
	obj.basis = shootPoint.global_transform.basis
	get_tree().get_first_node_in_group("CurrentScene").add_child.call_deferred(obj)

	
func update_behavior():
	if not timer.is_stopped():
		timer.stop()
		
	if player_sensor.player_in_range:
		state = WaspState.ACTIVE
	else:
		state = WaspState.IDLE
	
	match state:
		WaspState.IDLE:
			if randf() < 0.5:
				if global_position.distance_to(startPosition) < 6:
					targetDirection = Vector3(randf_range(-1.0, 1.0),randf_range(-0.5, 0.5),randf_range(-1.0, 1.0))
				else:
					targetDirection = global_position.direction_to(startPosition) + Vector3(randf_range(-1.0,1.0),randf_range(-1.0,1.0),randf_range(-1.0,1.0))
				targetFacing = targetDirection
				reset_timer(randf_range(4.5, 5.5))
			else:
				targetDirection = Vector3.ZERO
				reset_timer(randf_range(2.5, 3.5))
		WaspState.ACTIVE:
			if player_sensor.get_player_distance() > 6:
				if randf() < 0.9:
					targetDirection = global_position.direction_to(player_sensor.get_player_position() + Vector3(randf_range(-1.0, 1.0),randf_range(-0.5, 0.5),randf_range(-1.0, 1.0)))
					reset_timer(randf_range(0.5, 1.0))
				else:
					targetDirection = Vector3.ZERO
					reset_timer(randf_range(2.5, 3.5))
			else:
				if randf() < 0.9:
					targetDirection = Vector3(randf_range(-1.0, 1.0),randf_range(-0.5, 0.5),randf_range(-1.0, 1.0))
					reset_timer(randf_range(0.5, 1.0))
				else:
					targetDirection = Vector3.ZERO
					reset_timer(randf_range(0.5, 1.5))

func _physics_process(delta):
	velocity = targetDirection.normalized() * float_speed
	rotation.y = lerp_angle(rotation.y, atan2(targetFacing.x, targetFacing.z), delta * deg_to_rad(160))
	move_and_slide()
