extends Node

@export var monologue : Monologue
@export var object_holder : Node
@export var objective_label : ColorRect
@export var objective_label_timer : Timer
@export var boss_remote_transform : RemoteTransform3D
@export var armor_queen : ArmorQueen
@export var boss_path : Path3D

var boss_node_parent : Node
var closest_node : Node3D
var closest_behind : bool
var show_closest : bool

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
	pass

func _process(delta):
	if Input.is_action_just_pressed("context"):
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
	choose_nearest_objective()
	show_closest = true
	objective_label_timer.start()
	await objective_label_timer.timeout
	show_closest = false
	pass
	
func mission_encounter_resolved():
	encountersResolved += 1
	encounter_progress()

func encounter_progress():
	
	if encountersResolved == 1:
		monologue.show_monologue("Otis","Elimination confirmed. Several targets remain, get at them, Angel.")
		#await get_tree().create_timer(6).timeout
		#activate_boss()
		
	if encountersResolved == 4:
		monologue.show_monologue("Otis","Half of the targets remain. Keep it going!")
		
	if encountersResolved == 7:
		monologue.show_monologue("Otis","One target remains, Angel. You're almost home.")
		
	if encountersResolved == 8:
		if luresActivated < 4:
			monologue.show_monologue("Otis","Objective achieved. Pack it up and return to base.")
		else:
			activate_boss()

func activate_boss():
	monologue.show_monologue("Otis","Objective achieved. Pack it up and... Wait...")
	await get_tree().create_timer(7).timeout
	armor_queen.start_following(boss_path.curve.get_point_position(0))
	monologue.show_monologue("Otis","Angel! That massive enemy is closing in! It's a Formic Queen!")
	
func activate_formic_lure():
	if encountersResolved < 8:
		luresActivated += 1
		lure_progress()
	
func lure_progress():
	if luresActivated == 1:
		monologue.show_monologue("Otis","That panel is generating some sort of sub-sonic frequency. I'll look into it from here.")
	
	if luresActivated == 2:
		monologue.show_monologue("Otis","Formic activity in the surrounding sectors is shifting. Be careful, Angel")

	if luresActivated == 3:
		monologue.show_monologue("Otis","Angel, those terminals are Formic Lures. You're affecting the Formic traffic in the surrounding sectors.")
		
	if luresActivated == 4:
		monologue.show_monologue("Otis","A massive heat signature is headed your way, Angel. Perhaps you can get out of there before it arrives?")

func boss_defeated():
	if encountersResolved == 8 and luresActivated == 4:
		monologue.show_monologue("Otis","Excellent job, Angel! Pallas Athena can clear up the rest. Let's get you home.")
	
