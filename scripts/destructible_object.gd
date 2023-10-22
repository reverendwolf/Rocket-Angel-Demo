extends Area3D

@export var death_animation : AnimationPlayer
@export var destroy_spawn : PackedScene

func _ready():
	if death_animation:
		death_animation.stop(false)

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
