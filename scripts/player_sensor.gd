class_name PlayerSensor
extends Node3D

signal PlayerSeen
signal PlayerLost
signal PlayerInRange

var player_seen : bool = false
var player_in_range : bool = false
var player_ref : CharacterBody3D

@onready var look_point : Node3D = $RaycastPoint

#lost (outside range or LOS)
#seen (inside range or LOS)

#sight range is a sphere

#on player enter range, take player reference, set seen false
#while player has reference, check LOS and angle
#if within angle and LOS clear, set seen true and emit playerSeen
#on player exit range, drop player reference, set seen false
#if player was seen, emit playerLost

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if player_ref:
		var space_state = get_world_3d().direct_space_state
		
		var direction : Vector3 = look_point.global_position - player_ref.global_position
		var angle : float =  rad_to_deg(direction.angle_to(-get_parent().transform.basis.z))
		
		if angle < 80.0:
			var raycast = PhysicsRayQueryParameters3D.create(look_point.global_position, player_ref.global_position)
			raycast.set_exclude([get_parent().get_rid()])
			
			var raycastHit = space_state.intersect_ray(raycast)
			
			if raycastHit:
				if raycastHit.collider == player_ref and not player_seen:
					player_seen = true
					PlayerSeen.emit()
			
		pass
		


func _on_sight_area_body_entered(body):
	if body.is_in_group("PlayerOnly"):
		player_ref = body
		player_seen = false
		player_in_range = true
		PlayerInRange.emit()



func _on_sight_area_body_exited(body):
	if body.is_in_group("PlayerOnly"):
		if player_seen:
			PlayerLost.emit()
		player_ref = null
		player_seen = false
		player_in_range = false
		
func get_player_position() -> Vector3:
	if player_ref:
		return player_ref.global_position
	else:
		return Vector3.ZERO

func get_player_distance() -> float:
	if player_ref:
		return global_position.distance_to(player_ref.global_position)
	else:
		return -1
		
func force_player_reference():
	player_ref = get_tree().get_first_node_in_group("PlayerOnly")
	#don't emit a signal here, it's a special case
