extends Node

enum MS_STATE
{
	INTRO,
	SELECT,
	BRIEFING
}

var state : MS_STATE

@export var anim_player : AnimationPlayer
@export var music : AudioStream
@onready var impact : AudioStreamPlayer = $Impact

@onready var monologue : Monologue = $"Control/Monologue Display" as Monologue

@export_file var stage1 : String

@export var selector : Node3D
@export var selection_nodes : Array[Node3D]

var intro_done : bool = false
var briefing_done : bool = false

signal introComplete

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("play_intro")
	call_deferred("play_music")
	state = MS_STATE.INTRO
	for node in selection_nodes:
		node.scale = Vector3.ZERO
		pass
	selector.scale = Vector3.ZERO
	pass # Replace with function body.

func play_music():
	await get_tree().create_timer(1).timeout
	MusicMaster.play_now(music)

func play_intro():
	await anim_player.animation_finished
	
	for node in selection_nodes:
		var tween = node.create_tween()
		tween.tween_property(node, "scale", Vector3.ONE, 0.25)
		impact.play()
		await get_tree().create_timer(0.15).timeout
		pass
	
	await get_tree().create_timer(0.25).timeout
	var tween = selector.create_tween()
	tween.tween_property(selector, "scale", Vector3.ONE, 0.25)
	impact.play()
	intro_done = true
	
	state = MS_STATE.SELECT
	pass

func stage_intro():
	state = MS_STATE.BRIEFING
	await anim_player.animation_finished
	get_tree().get_first_node_in_group("MainScene").load_new_scene(stage1)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		match state:
			MS_STATE.INTRO:
				if anim_player.is_playing():
					anim_player.advance(100)
				pass
			MS_STATE.SELECT:
				anim_player.play("stage1")
				stage_intro()
				pass
			MS_STATE.BRIEFING:
				if anim_player.is_playing():
					anim_player.advance(100)
				pass
