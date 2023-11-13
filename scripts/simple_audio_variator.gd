extends AudioStreamPlayer3D

@export var min_pitch : float = 0.95
@export var max_pitch : float = 1.15
# Called when the node enters the scene tree for the first time.
func _ready():
	pitch_scale =randf_range(min_pitch, max_pitch)
