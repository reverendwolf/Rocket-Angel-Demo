extends Control

@export var settings_screen : PackedScene

@onready var first_control : Control = $VBoxContainer/Settings
var music_bus : int
var current_screen : Control
# Called when the node enters the scene tree for the first time.
func _ready():
	music_bus = AudioServer.get_bus_index("Music")
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		
		AudioServer.set_bus_effect_enabled(music_bus, 0, visible)
		
		if visible:
			first_control.grab_focus()
			
		if not visible:
			if current_screen:
				current_screen.queue_free()
				current_screen = null
		
	pass

func show_settings():
	print("show settings?")
	var screen = settings_screen.instantiate()
	add_child(screen)
	current_screen = screen
	pass
