extends Area3D

class_name Projectile

@export var SPEED = 3.0
@export var EXPLOSION : PackedScene

@export var damage_dealer : DamageDealer

@export var tail : CPUParticles3D

var projectile_owner : Node

var speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = SPEED * 0.5

func assign_owner(new_owner : Node):
	projectile_owner = new_owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += -global_transform.basis.z * delta * speed
	speed = lerp(speed, SPEED, delta)
	
func explode():
	if EXPLOSION != null:
		var e = EXPLOSION.instantiate()
		e.position = global_position
		e.basis = basis
		get_tree().root.add_child(e)
	
	if tail:
		tail.reparent(get_tree().get_first_node_in_group("CurrentScene"))
		tail.emitting = false
		
	queue_free()

func _on_body_entered(body):
	if body == projectile_owner:
		return
	
	if damage_dealer:
		damage_dealer.deal_damage(body)
	
	explode()

func _on_timer_timeout():
	explode()
