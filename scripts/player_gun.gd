extends Node3D

@onready var shoot_point = $"Shoot Point"

@export var player_parent : Node3D
@export var normal_rocket : PackedScene
@export var super_rocket : PackedScene

const MAX_MAGAZINE = 6
const MAX_SECONDARY = 9
const SHOT_COOLDOWN = 0.55
const RELOAD_DELAY = 1.25

var magazine = MAX_MAGAZINE
var secondary = MAX_SECONDARY
var shot_cooldown = 0.0
var reload_delay = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_process_cooldowns(delta)
	
	if reload_delay > 0.0 or shot_cooldown > 0.0:
		return
	
	if Input.is_action_just_pressed("shoot_p"):
		if magazine > 0:
			_shoot_primary()
		else:
			_reload()
			
	if Input.is_action_just_pressed("shoot_a") and secondary > 0:
		_shoot_secondary()
		
	if Input.is_action_just_pressed("reload") and magazine < MAX_MAGAZINE:
		_reload()
	
	
func _shoot_primary():
	magazine -= 1
	shot_cooldown = SHOT_COOLDOWN
	var r = normal_rocket.instantiate() as Projectile
	r.position = shoot_point.global_position
	r.basis = shoot_point.global_transform.basis
	r.assign_owner(player_parent)
	get_tree().root.add_child(r)

func _shoot_secondary():
	shot_cooldown = SHOT_COOLDOWN * 2
	secondary -= 1
	var r = super_rocket.instantiate()
	r.position = shoot_point.global_position
	r.basis = shoot_point.global_transform.basis
	get_tree().root.add_child(r)
	
func _reload():
	print("reload")
	reload_delay = RELOAD_DELAY
	magazine = MAX_MAGAZINE
	
func _process_cooldowns(time):
	if(shot_cooldown >= 0.0):
		shot_cooldown -= time
		
	if(reload_delay >= 0.0):
		reload_delay -= time
		if reload_delay < 0.0:
			print("reload complete")
