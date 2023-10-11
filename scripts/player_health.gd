extends Node
class_name PlayerHealth

@onready var health_display : RichTextLabel = $"../Player Hud/ArmorLabel"

const LOWMAX = 100
const HIGHMAX = 150

var currentMax

var currentHealth : int
var tokens : int


# Called when the node enters the scene tree for the first time.
func _ready():
	currentHealth = LOWMAX
	currentMax = LOWMAX
	tokens = 0
	_update_health()

func damage(value : int):
	currentHealth = clamp(currentHealth - value, 0, currentMax)
	_update_health()
	
func addToken():
	tokens += 1
	if tokens >= 3:
		currentMax = HIGHMAX
		
func _update_health():
	if health_display:
		health_display.text = str(currentHealth) + "/" + str(currentMax) + "\n" + str(tokens) + "/3"
