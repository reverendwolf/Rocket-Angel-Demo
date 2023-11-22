extends Node
class_name  MainScene

@export var scene_holder : Node
@export var screen_fader : AnimationPlayer

@export_file var starting_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
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
	await screen_fader.animation_finished
	
func show_screen():
	screen_fader.play_backwards("transition")
	await screen_fader.animation_finished
	
func load_new_scene(path : String):
	scene_transition(path)

func scene_transition(path : String):
	await cover_screen()
	
	for child in scene_holder.get_children():
		child.queue_free()
	
	
	
	var new_scene = load(path).instantiate()
	
	scene_holder.add_child(new_scene)
	await get_tree().create_timer(1.5).timeout
	await show_screen()

func _unhandled_input(event):
	if(event is InputEventKey):
		if(event.keycode == KEY_ESCAPE):
			get_tree().quit()
