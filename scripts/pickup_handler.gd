extends Area3D

@onready var player_gun : PlayerGun = $"../Gun" as PlayerGun
@onready var player_health : PlayerHealth = $"../PlayerHealth" as PlayerHealth

signal pickup_event
signal pickup_power
signal pickup_ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.	

func _on_area_entered(area):
	var used : bool = false
	if area is PickupDef:
		match area.pickup_type:
			area.PickupType.SHARD:
				if player_health.currentHealth < 100:
					player_health.heal(2)
					get_tree().get_first_node_in_group("MainScene").pulse_blur(0.5)
					used = true
			area.PickupType.PLATE:
				if player_health.currentHealth < 100:
					player_health.heal(25)
					get_tree().get_first_node_in_group("MainScene").pulse_blur(0.75)
					used = true
			area.PickupType.CHARGE:
				player_health.heal(200,true)
				get_tree().get_first_node_in_group("MainScene").pulse_blur(0.75)
				used = true
			area.PickupType.AMMO:
				if player_gun.secondary < 9:
					player_gun.add_ammo(1)
					get_tree().get_first_node_in_group("MainScene").pulse_blur(0.85)
					used = true
		
		if used:
			pickup_event.emit()
			if area.pickup_type == area.PickupType.AMMO:
				pickup_ammo.emit()
			else:
				pickup_power.emit()
			area.queue_free()
		
	pass # Replace with function body.
