extends Node
class_name PlayerHealth

@onready var health_display : RichTextLabel = $"../Player Hud/Panel/ArmorLabel"
@onready var timer : Timer = $Timer

var currentHealth : int

var invulerable : bool

func set_invulnerable(value : bool):
	invulerable = value

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = 150
	_update_health()

func damage(value : int):
	if not invulerable:
		currentHealth = clamp(currentHealth - value, 0, 200)
	_update_health()
	
func heal(value : int, overcharge : bool = false):
	if overcharge:
		currentHealth = clamp(currentHealth + value, 0, 200)
	elif currentHealth < 100:
		currentHealth = clamp(currentHealth + value, 0, 100)
	_update_health()
	
func _update_health():
	if health_display:
		print("update")
		health_display.text = str(currentHealth)
		if currentHealth > 100 and timer.is_stopped():
			print("timer")
			timer.start()
		
func health_decay():
	if currentHealth > 100:
		currentHealth -= 1
		_update_health()
