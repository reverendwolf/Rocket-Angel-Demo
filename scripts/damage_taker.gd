extends Node

class_name DamageTaker

signal damage_taken(value : int)
signal any_damage_received

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func damage(value : int):
	emit_signal("any_damage_received")
	emit_signal("damage_taken", value)
