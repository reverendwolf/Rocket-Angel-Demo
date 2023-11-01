class_name PathFollower
extends PathFollow3D

@export var follow_speed : float = 3.5

var following : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	following = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if following:
		progress += delta * follow_speed

func start_following():
	following = true
