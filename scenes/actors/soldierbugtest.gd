extends CharacterBody3D

@export var anim : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Stand")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_label_pressed(KEY_1):
		anim.play("Walk")
	
	if Input.is_key_label_pressed(KEY_2):
		anim.play("Chase")
		
	if Input.is_key_label_pressed(KEY_2):
		anim.play("Melee")
	
	pass
