extends Control

@export_file var title_screen : String

@export var music : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicMaster.play_now(music)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func return_title():
	get_tree().get_first_node_in_group("MainScene").load_new_scene(title_screen)
	MusicMaster.fade_out(1.0)
