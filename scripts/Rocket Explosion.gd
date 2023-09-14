extends Node3D

var time = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = lerp(Vector3.ONE, Vector3.ONE * 2, 1.0 - time)
	global_scale(scale)
	time -= delta
	if time <= 0.0:
		queue_free()
