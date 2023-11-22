extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Quit.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func commit_exit():
	get_tree().quit()
