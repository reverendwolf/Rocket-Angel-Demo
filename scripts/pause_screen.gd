extends Control

enum PAUSE_MENU
{
	OFF,
	MAIN,
	SETTINGS,
	MANUAL
}

var pause_state : PAUSE_MENU

@export var settings_screen : PackedScene
@export var manual_screen : PackedScene

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
		if pause_state == PAUSE_MENU.OFF:
			show_pause()
			first_control.grab_focus()
		else:
			hide_pause()
			_clear_screen()
				
	if Input.is_action_just_pressed("sprint"):
		if pause_state != PAUSE_MENU.OFF and pause_state != PAUSE_MENU.MAIN:
			_clear_screen()
			pause_state = PAUSE_MENU.MAIN
			pass
		elif pause_state == PAUSE_MENU.MAIN:
			_clear_screen()
			hide_pause()
	pass
	
func _clear_screen():
	if current_screen:
		current_screen.queue_free()
		current_screen = null
		first_control.grab_focus()
	
func _pause_stuff(status : bool):
	get_tree().paused = status
	visible = status
	AudioServer.set_bus_effect_enabled(music_bus, 0, status)
	
func show_pause():
	_pause_stuff(true)
	pause_state = PAUSE_MENU.MAIN

func hide_pause():
	_pause_stuff(false)
	pause_state = PAUSE_MENU.OFF

func show_settings():
	pause_state = PAUSE_MENU.SETTINGS
	var screen = settings_screen.instantiate()
	add_child(screen)
	current_screen = screen
	pass

func show_manual():
	pause_state = PAUSE_MENU.MANUAL
	var screen = manual_screen.instantiate()
	add_child(screen)
	current_screen = screen
