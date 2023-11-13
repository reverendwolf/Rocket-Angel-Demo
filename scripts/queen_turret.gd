extends Node3D
class_name QueenTurret

@export var projectile : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(global_position - Vector3.DOWN, Vector3.FORWARD, true)
	pass
	
func shoot():
	var obj = projectile.instantiate() as Projectile
	obj.assign_owner(get_parent())
	get_tree().root.add_child(obj)
	obj.position = global_position
	obj.global_rotation = global_rotation
	

