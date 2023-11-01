extends Node

signal encounter_complete

var child_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	child_count = get_child_count()
	for child in get_children():
		child.tree_exiting.connect(_child_removed)

func _child_removed():
	child_count -= 1
	if child_count == 0:
		emit_signal("encounter_complete")
