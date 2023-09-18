extends Node

class_name Health

@export var max = 10
@export var cur = 1

signal healthDepleted

# Called when the node enters the scene tree for the first time.
func _ready():
	cur = max


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func damage(dmg : int):
	cur -= dmg
	health_check()
	
func restore(dmg : int):
	cur += dmg
	health_check()
	
func health_check():
	cur = clamp(cur, 0, max)
	if cur == 0:
		emit_signal("healthDepleted")


func _on_damage_taker_damage_taken(value):
	damage(value)
