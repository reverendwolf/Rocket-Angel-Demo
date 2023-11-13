extends Area3D

@onready var player_gun : PlayerGun = $"../Gun" as PlayerGun
@onready var player_health : PlayerHealth = $"../PlayerHealth" as PlayerHealth

signal pickup_event

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.	

func _on_area_entered(area):
	var used : bool = false
	if area is PickupDef:
		match area.pickup_type:
			area.PickupType.SHARD:
				if player_health.currentHealth < 100:
					player_health.heal(15)
					used = true
			area.PickupType.PLATE:
				if player_health.currentHealth < 100:
					player_health.heal(35)
					used = true
			area.PickupType.CHARGE:
				player_health.heal(200,true)
				used = true
			area.PickupType.AMMO:
				if player_gun.secondary < 9:
					player_gun.add_ammo(1)
					used = true
		
		if used:
			pickup_event.emit()
			area.queue_free()
		
	pass # Replace with function body.
