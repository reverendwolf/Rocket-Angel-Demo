extends PhysicsBody3D

@export var death_animation : AnimationPlayer
@export var destroy_spawn : PackedScene

func _ready():
	pass

func _on_health_depleted():
	spawn_death()
	queue_free()
		

func spawn_death():
	if destroy_spawn:
		var obj = destroy_spawn.instantiate()
		obj.position = position
		obj.basis = transform.basis
		get_tree().root.add_child(obj)
