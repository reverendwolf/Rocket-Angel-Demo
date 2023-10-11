extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var death_animation : AnimationPlayer
@export var destroy_spawn : PackedScene

func _ready():
	if death_animation:
		death_animation.stop(false)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector3.ZERO
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_health_depleted():
	if death_animation:
		death_animation.play("fire_barrel_death")
	else:
		spawn_death()
		queue_free()

func spawn_death():
	if destroy_spawn:
		var obj = destroy_spawn.instantiate()
		obj.position = position
		obj.basis = transform.basis
		get_tree().root.add_child(obj)
