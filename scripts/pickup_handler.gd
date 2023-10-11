extends Area3D

@onready var player_gun : PlayerGun = $"../Gun"
@onready var player_health : PlayerHealth = $"../PlayerHealth"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.	

func _on_area_entered(area):
	if area is PickupDef:
		match area.pickup_type:
			area.PickupType.SHARD:
				if player_health:
					player_health.damage(-25)
			area.PickupType.PLATE:
					player_health.addToken()
					player_health.damage(-35)
					
			area.PickupType.AMMO:
				if player_gun:
					player_gun.add_ammo(1)
		
		area.queue_free()
		
	pass # Replace with function body.
