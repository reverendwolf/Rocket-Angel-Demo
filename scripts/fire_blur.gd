extends Node

@export var blur_strength := 0.75
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_first_node_in_group("MainScene").pulse_blur(blur_strength)
	pass # Replace with function body.

