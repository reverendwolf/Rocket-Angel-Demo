extends Node

class_name Health

@export var maxHealth = 10
@export var curHealth = 1

signal healthDepleted

# Called when the node enters the scene tree for the first time.
func _ready():
	curHealth = maxHealth
	
func damage(dmg : int):
	curHealth -= dmg
	health_check()
	
func restore(dmg : int):
	curHealth += dmg
	health_check()
	
func health_check():
	curHealth = clamp(curHealth, 0, maxHealth)
	if curHealth == 0:
		emit_signal("healthDepleted")
