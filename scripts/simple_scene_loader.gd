extends Node

@export_file var scene_path : String

func do_load_scene():
	get_tree().get_first_node_in_group("MainScene").load_new_scene(scene_path)
