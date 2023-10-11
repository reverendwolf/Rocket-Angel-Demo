extends Node3D

var grow = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	grow += delta * 1.5
	scale = Vector3.ONE * grow * grow
	global_scale(scale)


func _on_timer_timeout():
	queue_free()
