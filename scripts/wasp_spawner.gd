extends Node3D

@onready var timer : Timer = $Timer as Timer

@export var spawn_object : PackedScene
@export var min_time : float = 2.5
@export var max_time : float = 5.0
@export var max_children : int = 4

var cur_children = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(spawn)
	reset_timer()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn():
	if cur_children < max_children:
		var obj = spawn_object.instantiate()
		obj.position = global_position
		obj.basis = transform.basis
		obj.tree_exiting.connect(child_killed)
		cur_children += 1
		
		get_tree().get_first_node_in_group("CurrentScene").add_child.call_deferred(obj)
		
		if cur_children < max_children:
			reset_timer()

func reset_timer():
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()

func child_killed():
	cur_children -= 1
	reset_timer()
