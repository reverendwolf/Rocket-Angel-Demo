extends Node

class_name Health

@export var maxHealth = 10
@export var curHealth = 1

signal healthDepleted
signal healthLowered
signal healthRaised

# Called when the node enters the scene tree for the first time.
func _ready():
	curHealth = maxHealth
	
func damage(dmg : int):
	curHealth -= dmg
	health_check(false)
	
func restore(dmg : int):
	curHealth += dmg
	health_check(true)
	
func health_check(health_raised):
	curHealth = clamp(curHealth, 0, maxHealth)
	if curHealth == 0:
		healthDepleted.emit()
	elif health_raised:
		healthRaised.emit()
	else:
		healthLowered.emit()

func get_health_pct() -> float:
	print(str(float(curHealth) / float(maxHealth)))
	return float(curHealth) / float(maxHealth)
