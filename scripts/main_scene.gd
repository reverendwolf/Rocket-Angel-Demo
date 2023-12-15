extends Node
class_name  MainScene

@export var scene_holder : Node
@export var screen_fader : AnimationPlayer

@onready var empty_button : BaseButton = %EmptyButton
@onready var debug_label : Label = %"Debug Label"

@export var screen_blur : BlurManager

@export_file var starting_scene : String

var transitioning : bool = false
var pulsing : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	screen_blur.rect.visible = false
	var init_scene = load(starting_scene).instantiate()
	scene_holder.add_child(init_scene)
	call_deferred("show_screen")

static func initialize_preferences():
	var prefs : UserPrefs = UserPrefs.load()
	for i in len(prefs.audioSettings):
		print( str(i) + ": " + str(prefs.audioSettings[i]))
		AudioServer.set_bus_volume_db(i, linear_to_db(prefs.audioSettings[i]))

func cover_screen():
	screen_fader.play("transition")
	MusicMaster.fade_out(1.0)
	await screen_fader.animation_finished
	
func show_screen():
	screen_fader.play_backwards("transition")
	await screen_fader.animation_finished
	
func load_new_scene(path : String):
	scene_transition(path)

func scene_transition(path : String):
	if transitioning: return
	
	transitioning = true
	empty_button.grab_focus()
	
	await cover_screen()
	
	for child in scene_holder.get_children():
		debug_label.text = str(scene_holder.get_child_count())
		child.queue_free()
		await get_tree().process_frame
		
	
	await get_tree().process_frame
	
	var new_scene = load(path).instantiate()
	
	scene_holder.add_child(new_scene)
	await get_tree().create_timer(1.5).timeout
	await show_screen()
	transitioning = false

func _unhandled_input(event):
	if(event is InputEventKey):
		if(event.keycode == KEY_ESCAPE):
			get_tree().quit()

func pulse_blur(amount : float):
	if pulsing: return
	screen_blur.rect.visible = true
	var tween = get_tree().create_tween()
	tween.tween_method(screen_blur.set_blend, amount, 0.0, 1.0)
	await tween.finished
	screen_blur.rect.visible = false
	pass
