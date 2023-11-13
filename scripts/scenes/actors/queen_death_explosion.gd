class_name QueenExplosionSpawner
extends Node3D

@export var spawn_object : PackedScene

var spawning : bool = false
var cooldown : float = 0.0

func start_spawning():
	spawning = true
	cooldown = randf()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not spawning: return
	
	if cooldown >= 0.0: cooldown -= delta
	else:
		cooldown = randf_range(1.25, 2.25)
		var obj = spawn_object.instantiate()
		add_child(obj)
		var gauss_x : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
		var gauss_y : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
		var gauss_z : float = randf_range(-0.5, 0.5) + randf_range(-0.5, 0.5)
		
		obj.position = Vector3(gauss_x, gauss_y, gauss_z) * 4.0
		obj.rotate_object_local(Vector3.UP, randi_range(-180,180))

	pass
