extends Node

class_name Health

@export var maxHealth = 10
@export var curHealth = 1

var died = false;
var cooldown := 0.0

signal healthDepleted
signal healthLowered
signal healthRaised

# Called when the node enters the scene tree for the first time.
func _ready():
	curHealth = maxHealth
	
func _process(delta):
	if cooldown >= 0.0:
		cooldown -= delta
	
func damage(dmg : int):
	if cooldown > 0.0: return
	
	curHealth -= dmg
	health_check(false)
	
func restore(dmg : int):
	if cooldown > 0.0: return
	
	curHealth += dmg
	health_check(true)
	
func health_check(health_raised):
	if died: return
	
	curHealth = clamp(curHealth, 0, maxHealth)
	if curHealth == 0:
		healthDepleted.emit()
		died = true
	elif health_raised:
		healthRaised.emit()
	else:
		healthLowered.emit()
		
	cooldown = 0.25

func get_health_pct() -> float:
	print(str(float(curHealth) / float(maxHealth)))
	return float(curHealth) / float(maxHealth)
