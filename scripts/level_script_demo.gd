extends Node

@export var monologue : Monologue
@export var object_holder : Node
@export var objective_label : ColorRect
@export var objective_label_timer : Timer

var closest_node : Node3D
var closest_behind : bool
var show_closest : bool

var encountersResolved : int = 0
var luresActivated : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("starting_message")
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
	
func starting_message():
	await get_tree().create_timer(0.25).timeout
	monologue.show_monologue("System Message","Main System engaging combat mode.	")
	
func mission_encounter_resolved():
	encountersResolved += 1
	encounter_progress()

func encounter_progress():
	if encountersResolved == 1:
		monologue.show_monologue("Otis","That's it! Focus on those Heavy Pillbugs, Angel.")
		
	if encountersResolved == 4:
		monologue.show_monologue("Otis","That's most of them gone. Keep it up!")
		
	if encountersResolved == 7:
		monologue.show_monologue("Otis","They're almost clear, Angel.")
		
	if encountersResolved == 8:
		if luresActivated < 4:
			monologue.show_monologue("Otis","That's all of them in that sector. Pack it up and return to base.")
			await get_tree().create_timer(8).timeout
			monologue.show_monologue("System Message","Objective Achieved. System switched to Normal Mode")
		else:
			monologue.show_monologue("Otis","That's all of them in that sector... Wait...")
			await get_tree().create_timer(6).timeout
			monologue.show_monologue("Otis","Heads up, Angel! That massive enemy is closing in! It's a Formic Queen!")

func activate_formic_lure():
	if encountersResolved < 8:
		luresActivated += 1
		lure_progress()
	
func lure_progress():
	if luresActivated == 1:
		monologue.show_monologue("Otis","What is that? It's generating some sort of sub-sonic frequency.")
	
	if luresActivated == 2:
		monologue.show_monologue("Otis","The frequency is growing in power. I don't know what it means yet, but exercise caution.")

	if luresActivated == 3:
		monologue.show_monologue("Otis","Something is happening in the surrounding sectors, Angel. Formic activity is shifting. Mop things up quick!")
		
	if luresActivated == 4:
		monologue.show_monologue("Otis","Angel, I don't know what you've done, but a massive heat signature is headed your way. Try to get out of there before it arrives?")
