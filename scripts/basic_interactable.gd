class_name Interactable
extends Node

signal interaction

@export var one_shot : bool = true
var triggered : bool = false;

@export var light : OmniLight3D

func call_interaction():
	if one_shot and not triggered:
		interaction.emit()
		do_stuff()
		triggered = true

func do_stuff():
	if light: light.visible = true
