extends FSMState

@export var character_body : CharacterBody3D
@export var rotation_speed : float = 90
@export var shoot_point : Node3D
@export var projectile : PackedScene
@export var anim_tree : AnimationTree

var random_direction : Vector3
var shot_cooldown : float
var timer : Timer
var anim_state

func _ready():
	super._ready()
	timer = Timer.new()
	add_child(timer)

func enter_state():
	super.enter_state()
	anim_state = anim_tree["parameters/playback"]
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
	anim_state.travel("Ranged")
	
