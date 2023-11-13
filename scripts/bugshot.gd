class_name Bugshot
extends RigidBody3D

@export var damage_dealer : DamageDealer
@export var explosion : PackedScene

var projectile_owner : Node

@export var explode_on_contact : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if damage_dealer:
		damage_dealer.damageDealt.connect(damage_dealt)
	pass # Replace with function body.

func assign_owner(body):
	projectile_owner = body

func _on_body_entered(body):
	if linear_velocity != Vector3.ZERO:
		if damage_dealer and body != projectile_owner:
			damage_dealer.deal_damage(body)
			
	if explode_on_contact:
		explode()

func damage_dealt():
	explode()
	pass

func explode():
	var obj = explosion.instantiate()
	get_tree().get_first_node_in_group("CurrentScene").add_child(obj)
	obj.global_position = global_position
	obj.global_rotation = global_rotation
	queue_free()
