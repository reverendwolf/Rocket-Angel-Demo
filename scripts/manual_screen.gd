extends Control

@export var pages : Array[Texture2D]
@export var display : TextureRect
@onready var button : BaseButton = $TextureButton
var page : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	page = 0
	_update_page()
	button.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		_next_page()
	if Input.is_action_just_pressed("ui_left"):
		_prev_page()
	pass

func _update_page():
	display.texture = pages[page]
	pass

func _next_page():
	var old_page = page
	page = clamp(page + 1, 0, len(pages) - 1)
	if page != old_page: UISounds.play_paper()
	_update_page()
	
func _prev_page():
	var old_page = page
	page = clamp(page - 1, 0, len(pages) - 1)
	if page != old_page: UISounds.play_paper()
	_update_page()
	
func _exit_tree():
	UISounds.play_cancel()
