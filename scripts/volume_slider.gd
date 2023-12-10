extends HSlider

@export var busName : String
var bus_index : int
# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(busName)
	value = GlobalSettings.get_audiobus_value(bus_index)
	value_changed.connect(_on_value_changed)
	focus_entered.connect(UISounds.play_choose)
	
func _on_value_changed(new_value : float):
	GlobalSettings.set_audiobus_value(bus_index, new_value)
