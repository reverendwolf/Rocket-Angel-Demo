extends Node

class_name DamageTaker

signal damage_taken(value : int)
	
func damage(value : int):
	emit_signal("damage_taken", value)
