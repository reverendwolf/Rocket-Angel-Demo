extends Node
class_name PlayerHealth

@onready var health_display : RichTextLabel = $"../Player Hud/Panel/ArmorLabel"
@onready var timer : Timer = $Timer

var currentHealth : int

var invulerable : bool

signal health_depleted
signal health_damaged

func set_invulnerable(value : bool):
	invulerable = value

# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = 100
	_update_health()

func damage(value : int):
	if not invulerable and currentHealth > 0:
		currentHealth = clamp(currentHealth - value, 0, 200)
		health_damaged.emit()
		_update_health()
	
func heal(value : int, overcharge : bool = false):
	if overcharge:
		currentHealth = clamp(currentHealth + value, 0, 200)
	elif currentHealth < 100:
		currentHealth = clamp(currentHealth + value, 0, 100)
	_update_health()
	
func _update_health():
	if health_display:
		health_display.text = str(currentHealth)
		if currentHealth > 100 and timer.is_stopped():
			timer.start()
			
	if currentHealth == 0:
		await  get_tree().process_frame
		health_depleted.emit()
		
func health_decay():
	if currentHealth > 100:
		currentHealth -= 1
		_update_health()
