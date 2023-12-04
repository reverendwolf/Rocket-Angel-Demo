extends Node

signal updated

var prefs : UserPrefs

# Called when the node enters the scene tree for the first time.
func _ready():
	prefs = UserPrefs.load()
	pass # Replace with function body.

func commit_changes():
	print("Committing changes")
	prefs.save()
	updated.emit()

#region audio_bus
func set_audiobus_value(index : int, value : float):
	AudioServer.set_bus_volume_db(index, linear_to_db(value))
	prefs.audioSettings[index] = value
	
func get_audiobus_value(index : int) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(index))
#endregion


#region look_settings
func set_horizontal_look(value : float):
	prefs.lookSettings[0] = value
	
func set_vertical_look(value : float):
	prefs.lookSettings[1] = value
	
func get_horizontal_look() -> float:
	return prefs.lookSettings[0]
	
func get_vertical_look() -> float:
	return prefs.lookSettings[1]
	
func set_inverted(value : bool):
	print("inverted = " + str(value))
	prefs.invertLook = value
	
func get_inverted() -> bool:
	return prefs.invertLook
#endregion

func set_crosshair(value : bool):
	prefs.crosshair = value

func get_crosshair() -> bool:
	return prefs.crosshair

