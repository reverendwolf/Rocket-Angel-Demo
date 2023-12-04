extends Node

@onready var ui_select : AudioStreamPlayer = $Select
@onready var ui_choose : AudioStreamPlayer = $Choose
@onready var ui_cancel : AudioStreamPlayer = $Cancel
@onready var ui_toggle : AudioStreamPlayer = $Toggle
@onready var ui_paper :  AudioStreamPlayer = $Paper
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_select():
	ui_select.play()

func play_choose():
	ui_choose.play()

func play_cancel():
	ui_cancel.play()

func play_toggle():
	ui_toggle.play()

func play_paper():
	ui_paper.pitch_scale = randf_range(0.9, 1.15)
	ui_paper.play()
