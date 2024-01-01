extends Node

var music : AudioStreamPlayer
var music_bus : int

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	music = AudioStreamPlayer.new()
	add_child(music)
	
	music_bus = AudioServer.get_bus_index("Music")
	music.bus = "Music"
	music.volume_db = -4
	
	pass # Replace with function body.

func play_now(audio : AudioStream):
	if music.playing: music.stop()
	set_bus_value(1.0)
	music.stream = audio
	music.play(0.0)
	
func mute_now():
	set_bus_value(0.0)
	
func play_next(audio: AudioStream):
	await fade_out(1.0)
	play_now(audio)
	
func fade_out(time : float):
	var tween = get_tree().create_tween()
	tween.tween_method(set_bus_value, 1.0, 0.0, time)
	await tween.finished
	music.stop()

func fade_in(time : float):
	var tween = get_tree().create_tween()
	tween.tween_method(set_bus_value, 0.0, 1.0, time)
	await tween.finished
	
func set_bus_value(value : float):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value * GlobalSettings.get_audiobus_setting(music_bus)))
