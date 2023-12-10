extends Node

var can_sound : bool

@onready var ui_select : AudioStreamPlayer = $Select
@onready var ui_choose : AudioStreamPlayer = $Choose
@onready var ui_cancel : AudioStreamPlayer = $Cancel
@onready var ui_toggle : AudioStreamPlayer = $Toggle
@onready var ui_paper :  AudioStreamPlayer = $Paper
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func supress(supress_audio : bool):
	can_sound = !supress_audio

func play_select():
	if not can_sound: return
	ui_select.play()

func play_choose():
	if not can_sound: return
	ui_choose.play()

func play_cancel():
	if not can_sound: return
	ui_cancel.play()

func play_toggle():
	if not can_sound: return
	ui_toggle.play()

func play_paper():
	if not can_sound: return
	ui_paper.pitch_scale = randf_range(0.9, 1.15)
	ui_paper.play()
