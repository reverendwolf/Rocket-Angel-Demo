class_name Bugshot
extends RigidBody3D

@export var damage_dealer : DamageDealer
@export var explosion : PackedScene

var projectile_owner : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	if damage_dealer:
		damage_dealer.damageDealt.connect(damage_dealt)
	pass # Replace with function body.

func assign_owner(body):
	projectile_owner = body

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == projectile_owner:
		return
	
	if linear_velocity != Vector3.ZERO:
		if damage_dealer:
			damage_dealer.deal_damage(body)

func damage_dealt():
	explode()
	pass

func explode():
	var obj = explosion.instantiate()
	get_tree().get_first_node_in_group("CurrentScene").add_child(obj)
	obj.global_position = global_position
	obj.global_rotation = global_rotation
	queue_free()
