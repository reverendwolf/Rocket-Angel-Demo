class_name Monologue
extends ColorRect

@export var nameText : RichTextLabel
@export var dialogueText : RichTextLabel
@export var messageTimer : Timer
@export var characterTime : float = 0.01
@export var punctuationtime : float = 0.05

var s_name : String
var s_text : String
var monologue_working : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.
	
func show_monologue(speaker : String, monologue: String):
	if monologue_working:
		dialogueText.visible_characters = len(dialogueText.get_parsed_text())
		monologue_working = false
		messageTimer.stop()
		await get_tree().process_frame
	
	s_name = "[center]" + speaker + "[/center]"
	s_text = monologue
	display_text()

func display_text():
	monologue_working = true
	nameText.text = s_name
	dialogueText.bbcode_text = s_text
	dialogueText.visible_characters = 0
	
	visible = true
	
	while dialogueText.visible_characters < len(dialogueText.get_parsed_text()):
		dialogueText.visible_characters += 1
		if dialogueText.get_parsed_text()[dialogueText.visible_characters - 1] in ".,?!":
			await get_tree().create_timer(punctuationtime).timeout
		else:
			await get_tree().create_timer(characterTime).timeout
	
	if monologue_working:
		messageTimer.start()
		await messageTimer.timeout
	
	visible = false
	monologue_working = false;
	pass
