extends Node

class_name DamageTaker

signal damage_taken(value : int)
	
@export var ignore_groups : Array[String]
	
func damage(value : int):
	emit_signal("damage_taken", value)
