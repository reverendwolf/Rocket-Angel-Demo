extends Node

signal encounter_complete

var child_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	child_count = get_child_count()
	for child in get_children():
		child.tree_exited.connect(_child_removed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _child_removed():
	child_count -= 1
	if child_count == 0:
		print("encounter complete")
		emit_signal("encounter_complete")
