extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	focus_entered.connect(UISounds.play_choose)
	pass # Replace with function body.
