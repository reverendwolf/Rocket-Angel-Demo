extends Node

class_name DamageDealer

@export var damage = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func deal_damage(body):
	for child in body.get_children():
		if is_instance_of(child, DamageTaker):
			print("damaging " + child.get_parent().name + " for " + damage)
			child.damage(damage)
