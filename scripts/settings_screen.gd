extends Control

@export var first_control : Control
@export var horiz_slider : HSlider
@export var vert_slider : HSlider
@export var invert : CheckBox
@export var crosshair : CheckBox

# Called when the node enters the scene tree for the first time.
func _ready():
	UISounds.supress(true)
	first_control.grab_focus()
	tree_exiting.connect(closing)
	
	horiz_slider.value = GlobalSettings.get_horizontal_look()
	horiz_slider.value_changed.connect(GlobalSettings.set_horizontal_look)
	
	vert_slider.value = GlobalSettings.get_vertical_look()
	vert_slider.value_changed.connect(GlobalSettings.set_vertical_look)
	
	invert.button_pressed = GlobalSettings.get_inverted()
	invert.pressed.connect(GlobalSettings.set_inverted.bind(!invert.button_pressed))
	
	crosshair.button_pressed = GlobalSettings.get_crosshair()
	crosshair.pressed.connect(GlobalSettings.set_crosshair.bind(!crosshair.button_pressed))
	UISounds.supress(false)
	pass # Replace with function body.

func _exit_tree():
	UISounds.play_cancel()
	pass

	
func closing():
	horiz_slider.value_changed.disconnect(GlobalSettings.set_horizontal_look)
	vert_slider.value_changed.disconnect(GlobalSettings.set_vertical_look)
	GlobalSettings.commit_changes()
