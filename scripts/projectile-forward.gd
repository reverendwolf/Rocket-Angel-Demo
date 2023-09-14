extends Area3D

@export var SPEED = 3.0
@export var EXPLOSION : PackedScene

var speed = 0.0
var lifetime = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = SPEED * 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += -global_transform.basis.z * delta * speed
	speed = lerp(speed, SPEED, delta)
	lifetime -= delta
	if lifetime < 0.0:
		explode()
	
func explode():
	if EXPLOSION != null:
		var e = EXPLOSION.instantiate()
		e.position = global_position
		e.basis = basis
		get_tree().root.add_child(e)
	queue_free()


func _on_body_entered(_body):
	explode()
