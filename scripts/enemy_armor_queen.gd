extends CharacterBody3D
class_name ArmorQueen

@onready var boss_label : Control = $Control
@onready var health_bar : ProgressBar = $"Control/Boss Health" as ProgressBar
@onready var health : Health = $Health as Health

@export var path : Path3D
@export var path_follower : PathFollow3D
@export var player_sensor : PlayerSensor
@export var remote_transform : RemoteTransform3D

@export var follow_speed : float = 6.0

@export var turret_L : QueenTurret
@export var turret_R : QueenTurret

var last_position : Vector3

var start_path : bool
var follow_path : bool = false
var start_point : Vector3

var l_timer : float
var r_timer : float

var target_bar_pct : float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	follow_path = false
	start_path = false;
	boss_label.hide()
	l_timer = randf_range(2.5, 6.0)
	r_timer = randf_range(2.5, 6.0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = health.curHealth
	
	if follow_path:
		path_follower.progress += delta * follow_speed
		path.global_position = lerp(path.global_position, Vector3(0,5,0), delta)
		
		if l_timer >= 0.0:
			l_timer -= delta
		else:
			l_timer = randf_range(2.5, 6.0)
			turret_L.shoot()
			print("L")
		
		if r_timer >= 0.0:
			r_timer -= delta
		else:
			r_timer = randf_range(2.5, 6.0)
			turret_R.shoot()
			print("R")

func start_following(start : Vector3):
	add_to_group("Objectives")
	boss_label.show()
	follow_path = true

func _on_health_depleted():
	queue_free()
	
func _on_take_damage():
	target_bar_pct = health.get_health_pct()
	pass
