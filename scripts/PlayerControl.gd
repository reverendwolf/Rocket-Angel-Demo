extends CharacterBody3D

const SPEED = 3.5
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5
const BOOST_VELOCITY = 8.0
const GLIDE_FORCE = 0.2
const LOOK_SPEED = 1.85
const AIR_CONTROL = 3.0
const STOP_SPEED = 8.5

const GLIDE_FUEL_MAX = 4.0
const GLIDE_REFUEL_DELAY = 0.25
const BOOST_COOLDOWN_TIME = 10.0

const VIEW_BOB_FREQ = 3.5
const VIEW_BOB_AMP = 0.07

var bob_time = 0.0
var gliding = false
var crouching = false
var sprinting = false

var glide_fuel = 0.0
var boost_timer = 0.0
var glide_refuel_timer = 0.0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var fuel_bar = $"Player Hud/Fuel Bar"
@onready var boost_bar = $"Player Hud/Boost Bar"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.81

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	fuel_bar.max_value = GLIDE_FUEL_MAX
	glide_fuel = GLIDE_FUEL_MAX
	boost_bar.max_value = BOOST_COOLDOWN_TIME
	boost_bar.value = boost_bar.max_value

func _unhandled_input(event):
	if(event is InputEventKey):
		if(event.keycode == KEY_ESCAPE):
			get_tree().quit()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump and Glide
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		gliding = true
	
	if gliding and (Input.is_action_just_released("jump") or is_on_floor() or glide_fuel <= 0):
		gliding = false
		glide_refuel_timer = GLIDE_REFUEL_DELAY
		
	if gliding and glide_fuel > 0:
		velocity.y += GLIDE_FORCE
		glide_fuel -= delta
		
	if Input.is_action_just_pressed("boost") and boost_timer <= 0:
		velocity.y = BOOST_VELOCITY
		boost_timer = BOOST_COOLDOWN_TIME

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("lsleft", "lsright", "lsup", "lsdown")
	var look_dir = Input.get_vector("rsleft","rsright","rsup","rsdown")
	
	# sprinting speed
	if Input.is_action_just_pressed("sprint"):
		sprinting = !sprinting
	
	if input_dir.y > -0.75 and sprinting:
		sprinting = false
	
	var speed = SPRINT_SPEED if sprinting else SPEED
	
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

	move_and_slide()
	_handle_cooldowns(delta)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * VIEW_BOB_FREQ) * VIEW_BOB_AMP
	pos.x = cos(time * VIEW_BOB_FREQ / 2) * VIEW_BOB_AMP 
	return pos
	
func _handle_cooldowns(time):
	if boost_timer > 0.0:
		boost_timer -= time
		boost_timer = clamp(boost_timer, 0.0, BOOST_COOLDOWN_TIME)
		boost_bar.value = BOOST_COOLDOWN_TIME - boost_timer
		
	if glide_refuel_timer > 0:
		glide_refuel_timer -= time
		glide_refuel_timer = clamp (glide_refuel_timer, 0, GLIDE_REFUEL_DELAY)
	
	if !gliding and glide_fuel < GLIDE_FUEL_MAX and glide_refuel_timer <= 0.0:
		glide_fuel += time 
		glide_fuel = clamp(glide_fuel, 0.0, GLIDE_FUEL_MAX)
		
	fuel_bar.value = glide_fuel
