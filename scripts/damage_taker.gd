extends Node

class_name DamageTaker

signal damage_taken(value : int)
signal damage_event

@export var ignore_groups : Array[String]
	
func damage(value : int):
	damage_taken.emit(value)
	damage_event.emit()
