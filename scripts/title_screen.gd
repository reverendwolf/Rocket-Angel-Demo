extends Control

@onready var first_control : Control = $HBoxContainer/MainGame
# Called when the node enters the scene tree for the first time.

var held_screen : Node

@export var settings_screen : PackedScene
@export var manual_screen : PackedScene
@export var exit_screen : PackedScene

enum MENUSTATE
{
	MAIN,
	SETTINGS,
	MANUAL,
	EXIT
}

var current_state : MENUSTATE

func _ready():
	MainScene.initialize_preferences()
	current_state = MENUSTATE.MAIN
	first_control.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if current_state != MENUSTATE.MAIN:
			update_menu_state(MENUSTATE.MAIN)
		pass

func set_state_settings():
	update_menu_state(MENUSTATE.SETTINGS)

func set_state_manual():
	update_menu_state(MENUSTATE.MANUAL)

func set_state_exit():
	update_menu_state(MENUSTATE.EXIT)

func update_menu_state(new_state : MENUSTATE):
	if current_state != MENUSTATE.MAIN:
		held_screen.queue_free()
		first_control.grab_focus()
		pass
			
	match new_state:
		MENUSTATE.SETTINGS:
			held_screen = settings_screen.instantiate()
			add_child(held_screen)
			pass
		MENUSTATE.MANUAL:
			held_screen = manual_screen.instantiate()
			add_child(held_screen)
			pass
		MENUSTATE.EXIT:
			held_screen = exit_screen.instantiate()
			add_child(held_screen)
			pass
			
	current_state = new_state
	pass
