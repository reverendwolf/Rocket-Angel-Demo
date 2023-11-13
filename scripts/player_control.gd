extends CharacterBody3D
class_name FPSPlayer

const SPEED = 4.5
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4.5
const BOOST_VELOCITY = 8.0
const GLIDE_FORCE = 1.5
const LOOK_SPEED = 1.65
const AIR_CONTROL = 3.0
const STOP_SPEED = 8.5

const GLIDE_FUEL_MAX = 3.5
const GLIDE_REFUEL_DELAY = 0.25

const VIEW_BOB_FREQ = 3.5
const VIEW_BOB_AMP = 0.07

const GUN_BOB_AMP = 0.01

var bob_time = 0.0
var gliding = false
var crouching = false
var sprinting = false

var canStep = false

var glide_fuel = 0.0
var glide_refuel_timer = 0.0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var fuel_bar = $"Player Hud/ProgressBar"
@onready var footstep_cast = $FootstepShapeCast
@onready var footstepSound = $FootstepSound
@onready var interactionRaycast = $Head/Camera3D/InteractionRayCast
@onready var health = $PlayerHealth

@onready var floatJetSound = $FloatJetSound
@onready var jumpSound = $JumpSound
@onready var jumpJetSound = $JumpJetSound

@export var gun_holder : Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.81

var paused : bool = false

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	fuel_bar.max_value = GLIDE_FUEL_MAX
	glide_fuel = GLIDE_FUEL_MAX



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump and Glide
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump(JUMP_VELOCITY)
		jumpSound.play()
	
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		gliding = true
		floatJetSound.play()
	
	if gliding and (Input.is_action_just_released("jump") or is_on_floor() or glide_fuel <= 0):
		gliding = false
		floatJetSound.stop()
		glide_refuel_timer += GLIDE_REFUEL_DELAY
		
	if Input.is_action_just_pressed("interact") and interactionRaycast.is_colliding():
		var interaction = interactionRaycast.get_collider()
		if interaction is Interactable:
			interaction.call_interaction()

#	if gliding and glide_fuel > 0:
#		if(velocity.y < BOOST_VELOCITY):
#			velocity.y += GLIDE_FORCE
#		glide_fuel -= delta

	if gliding and glide_fuel > 0:
		if(velocity.y < GLIDE_FORCE):
			velocity.y = lerp(velocity.y, 0.0, 0.5)
		glide_fuel -= delta
		
	if Input.is_action_just_pressed("boost") and glide_fuel >= (GLIDE_FUEL_MAX * 0.75):
		jump(BOOST_VELOCITY)
		glide_fuel -= (GLIDE_FUEL_MAX * 0.65)
		glide_refuel_timer = (GLIDE_REFUEL_DELAY * 4)
		variator(jumpJetSound)
		jumpJetSound.play()

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("lsleft", "lsright", "lsup", "lsdown")
	var look_dir = Input.get_vector("rsleft","rsright","rsup","rsdown")
	
	# sprinting speed
	if Input.is_action_just_pressed("sprint"):
		sprinting = !sprinting
	
	if input_dir.y > -0.75 and sprinting:
		sprinting = false
	
	var speed = SPEED
	
	if sprinting:
		speed = SPRINT_SPEED
		glide_fuel -= (delta * 0.25);
	
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * STOP_SPEED)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * STOP_SPEED)
			sprinting = false
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * AIR_CONTROL)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * AIR_CONTROL)
		
	if look_dir:
		head.rotate_y(-look_dir.x * delta * LOOK_SPEED)
		camera.rotate_x(-look_dir.y * delta * LOOK_SPEED)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

	bob_time += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(bob_time)
	gun_holder.transform.origin = _gunbob(bob_time + 0.5)

	move_and_slide()
	_handle_cooldowns(delta)

func jump(jump_velocity : float):
	velocity.y = jump_velocity

func _footstep():
	#print("Step")
	if velocity.length() < SPEED:
		return
	
	footstepSound.pitch_scale = randf_range(0.9,1.1) * velocity.length() / SPEED
	footstepSound.play(0)
	
	pass

func variator(aud : AudioStreamPlayer3D):
	aud.pitch_scale = randf_range(0.85, 1.15)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	
	if canStep:
		if cos(time * VIEW_BOB_FREQ) > 0:
			_footstep()
			canStep = false
	else:
		if cos(time * VIEW_BOB_FREQ) < 0:
			canStep = true
	
	pos.y = sin(time * VIEW_BOB_FREQ) * VIEW_BOB_AMP
	pos.x = cos(time * VIEW_BOB_FREQ / 2) * VIEW_BOB_AMP 
	return pos

func _gunbob(time) -> Vector3:
	var pos = Vector3.ZERO
	
	pos.y = sin(time * VIEW_BOB_FREQ) * GUN_BOB_AMP
	pos.x = cos(time * VIEW_BOB_FREQ / 2) * GUN_BOB_AMP 
	return pos
	
func _handle_cooldowns(time):
		
	if glide_refuel_timer > 0:
		glide_refuel_timer -= time
		glide_refuel_timer = clamp (glide_refuel_timer, 0.0, 1.5)
	
	if !gliding and glide_fuel < GLIDE_FUEL_MAX and glide_refuel_timer <= 0.0 and !sprinting:
		glide_fuel += time 
		glide_fuel = clamp(glide_fuel, 0.0, GLIDE_FUEL_MAX)
		
	fuel_bar.value = GLIDE_FUEL_MAX - glide_fuel

func set_invulnerable(value : bool):
	health.set_invulnerable(value)
