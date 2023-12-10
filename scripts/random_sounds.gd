extends AudioStreamPlayer

@export var sounds : Array[AudioStream]
# Called when the node enters the scene tree for the first time.
func _ready():
	shuffle()
	pass # Replace with function body.

func shuffle():
	stream = sounds.pick_random()
	pitch_scale = randf_range(0.9,1.25)
	pass
