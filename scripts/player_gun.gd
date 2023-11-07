extends Node3D

class_name PlayerGun

@export var shoot_point : Node3D
@export var audio_source_shoot : AudioStreamPlayer3D

@export var player_parent : Node3D
@export var normal_rocket : PackedScene
@export var super_rocket : PackedScene

@onready var ammoLabel : RichTextLabel = $"../Player Hud/AmmoLabel"

const MAX_MAGAZINE = 6
const MAX_SECONDARY = 9
const SHOT_COOLDOWN = 0.55
const RELOAD_DELAY = 1.25

var magazine = MAX_MAGAZINE
var secondary = 1
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
			
	if Input.is_action_just_pressed("shoot_a") and (secondary > 0 || true):
		_shoot_secondary()
		
	if Input.is_action_just_pressed("reload") and magazine < MAX_MAGAZINE:
		_reload()
	
	
func _update_ammo_label():
	ammoLabel.text = str(magazine) + "/" + str(MAX_MAGAZINE) + "\n" + \
					str(secondary) + "/" + str(MAX_SECONDARY)
	
func _shoot_primary():
	magazine -= 1
	shot_cooldown = SHOT_COOLDOWN
	_update_ammo_label()
	if audio_source_shoot:
		audio_source_shoot.pitch_scale = randf_range(0.9, 1.15)
		audio_source_shoot.play()
	var r = normal_rocket.instantiate() as Projectile
	r.position = shoot_point.global_position
	r.basis = shoot_point.global_transform.basis
	r.assign_owner(player_parent)
	get_tree().root.add_child(r)

func _shoot_secondary():
	shot_cooldown = SHOT_COOLDOWN * 2
	secondary -= 1
	_update_ammo_label()
	if audio_source_shoot:
		audio_source_shoot.pitch_scale = randf_range(0.9, 1.15)
		audio_source_shoot.play()
	var r = super_rocket.instantiate() as Projectile
	r.position = shoot_point.global_position
	r.basis = shoot_point.global_transform.basis
	r.assign_owner(player_parent)
	get_tree().root.add_child(r)
	
func _reload():
	reload_delay = RELOAD_DELAY
	magazine = MAX_MAGAZINE
	_update_ammo_label()
	
func _process_cooldowns(time):
	if(shot_cooldown >= 0.0):
		shot_cooldown -= time
		
	if(reload_delay >= 0.0):
		reload_delay -= time
			
func add_ammo(value : int):
	secondary = clamp(secondary + value, 0, MAX_SECONDARY)
	_update_ammo_label()
