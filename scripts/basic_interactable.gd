class_name Interactable
extends Node

signal interaction

@export var one_shot : bool = true
var triggered : bool = false;

func call_interaction():
	if one_shot and not triggered:
		interaction.emit()
		triggered = true
