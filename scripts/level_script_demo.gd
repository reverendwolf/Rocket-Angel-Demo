extends Node

@export_file var mission_complete : String
@export_file var this_level : String
@export_file var to_title : String

@export var stage_music : AudioStream
@export var boss_music : AudioStream

@export var player : FPSPlayer
@export var monologue : Monologue
@export var objective_label : Control
@export var objective_label_timer : Timer
@export var objective_grid : Control
@export var objective_sound : AudioStreamPlayer
var scanning : bool
@export var boss_remote_transform : RemoteTransform3D
@export var armor_queen : ArmorQueen
@export var boss_path : Path3D

var boss_node_parent : Node
var closest_node : Node3D
var closest_behind : bool
var show_closest : bool
var standard_delay :float = 5.0

@export var boss_point : Node3D

var encountersResolved : int = 0
var luresActivated : int = 0

var quips : Array = [
	"Hey! Keep your gross goop off my suit!",
	"Otis owes me pizza and whiskey after this.",
	"Oh, I'm so pretty!",
	"Scratch one bogey. Buggy? Scratch one buggy!",
	"If you were as strong as you are ugly, I'd be in real trouble",
	"Your face, your ass, what's the difference?",
	"Score one more for the Rocket Angel!"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	objective_label.visible = false
	MusicMaster.play_now(stage_music)
	pass

func _process(_delta):
	if Input.is_action_just_pressed("context") and not scanning:
		show_nearest_objective()

	if not closest_node and show_closest:
		show_closest = false
		objective_label_timer.stop()

	if show_closest and closest_node:
		var closest_position = get_viewport().get_camera_3d().unproject_position(closest_node.global_position)
		var screen = get_viewport().get_visible_rect()
		closest_behind = get_viewport().get_camera_3d().is_position_behind(closest_node.global_position)
		closest_position.x = clamp(closest_position.x, 16, screen.size.x - 112)
		closest_position.y = clamp(closest_position.y, 16, screen.size.y - 32)
		if closest_behind:
			if closest_position.x >= screen.size.x / 2:
				closest_position.x = 16
			else:
				closest_position.x = screen.size.x - 112
			
			closest_position.y = screen.size.y / 2 - 16
			
		objective_label.position =  closest_position
		
	objective_label.visible = show_closest

func choose_nearest_objective():
	var player_body = get_tree().get_first_node_in_group("PlayerOnly")
	for obj in get_tree().get_nodes_in_group("Objectives"):
		var dist = player_body.global_position.distance_to(obj.global_position)
		if closest_node == null or dist < player_body.global_position.distance_to(closest_node.global_position):
			closest_node = obj

func show_nearest_objective():
	scanning = true
	choose_nearest_objective()
	if objective_sound.playing: objective_sound.stop()
	objective_sound.play(0.0)
	show_closest = true
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(objective_grid, "scale", Vector2.ONE, 0.25)
	objective_label_timer.start()
	await objective_label_timer.timeout
	show_closest = false
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(objective_grid, "scale", Vector2.ZERO, 0.25)
	scanning = false
	pass
	
func mission_encounter_resolved():
	encountersResolved += 1
	encounter_progress()

func encounter_progress():
	
	if encountersResolved == 1:
		monologue.show_monologue("Otis","Elimination confirmed. Several targets remain, keep it up, Angel.")
		#await get_tree().create_timer(6, false).timeout
		#activate_boss()
		
	if encountersResolved == 3:
		monologue.show_monologue("Otis","Half of the targets remain. Keep it going!")
		
	if encountersResolved == 5:
		monologue.show_monologue("Otis","One target remains, Angel. You're almost home.")
		
	if encountersResolved == 6:
		if luresActivated < 3:
			player.set_invulnerable(true)
			monologue.show_monologue("Otis","Objective achieved. Pack it up and return to base.")
			await get_tree().create_timer(standard_delay * 1.5, false).timeout
			get_tree().get_first_node_in_group("MainScene").load_new_scene(mission_complete)
			MusicMaster.fade_out(1.0)
		else:
			activate_boss()

func activate_boss():
	MusicMaster.fade_out(3.0)
	monologue.show_monologue("Otis","Objective achieved. Pack it up and... Wait...")
	await get_tree().create_timer(standard_delay, false).timeout
	monologue.show_monologue("Angel","Otis? What's going on?")
	await get_tree().create_timer(standard_delay, false).timeout
	monologue.show_monologue("Otis","Angel! That massive enemy is closing in! It's a Terranoid Queen!")
	armor_queen.start_following()
	MusicMaster.play_now(boss_music)
	
func activate_formic_lure():
	if encountersResolved < 6:
		luresActivated += 1
		lure_progress()
	
func lure_progress():
	await get_tree().create_timer(1.5).timeout
	
	if luresActivated == 1:
		monologue.show_monologue("Otis","That sound... That device is acting like a Terranoid Lure.")
		await get_tree().create_timer(standard_delay, false).timeout
		monologue.show_monologue("Angel","Who would want to lure Terranoids [i]into[/i] the city?") 
		await get_tree().create_timer(standard_delay, false).timeout
		monologue.show_monologue("Otis","Keep an eye out for more. I'll see what information I can find from here.")
		await get_tree().create_timer(standard_delay, false).timeout
		
	if luresActivated == 2:
		monologue.show_monologue("Angel","I found another Terranoid Lure.")
		await get_tree().create_timer(standard_delay, false).timeout
		monologue.show_monologue("Otis","Terranoid activity in the surrounding sectors is shifting. Be careful, Angel!")
		
	if luresActivated == 3:
		monologue.show_monologue("Otis","Was that another Lure, Angel? Something huge is moving toward your sector.")
		await get_tree().create_timer(standard_delay, false).timeout
		monologue.show_monologue("Angel","Better finish the job quick, then.")
		
func boss_defeated():
	if encountersResolved == 6 and luresActivated == 3:
		player.set_invulnerable(true)
		monologue.show_monologue("Angel","Otis? The Queen is down.")
		await get_tree().create_timer(standard_delay, false).timeout
		MusicMaster.fade_out(3.0)
		monologue.show_monologue("Otis","Angel! Are you alright?")
		await get_tree().create_timer(standard_delay, false).timeout
		monologue.show_monologue("Angel","I'm fine, but the Queen. It wasn't normal. It was... mechanized somehow.")
		await get_tree().create_timer(standard_delay, false).timeout
		monologue.show_monologue("Otis","Pallas Athena can clear up the rest. Let's get you home.")
		await get_tree().create_timer(standard_delay, false).timeout
		get_tree().get_first_node_in_group("MainScene").load_new_scene(mission_complete)

func reminder():
	monologue.show_monologue("Otis","Angel, don't forget about the actuators on your left hand. They'll activate the booster and floater jets on your suit!")
	await get_tree().create_timer(standard_delay, false).timeout

func reload_level():
	get_tree().get_first_node_in_group("MainScene").load_new_scene(this_level)
	pass
	
func quit_to_title():
	get_tree().get_first_node_in_group("MainScene").load_new_scene(to_title)
	pass
