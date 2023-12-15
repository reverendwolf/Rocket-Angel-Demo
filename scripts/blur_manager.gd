extends CanvasLayer
class_name BlurManager

var screen_tex : ImageTexture
@onready var rect : ColorRect = $AdditiveBlur

var blend := 0.0
var timer := 0.0

func _ready():
	blend = 0.0

func set_blend(value : float):
	blend = clamp(value, 0.0, 1.0)
	blend = value
	rect.material.set_shader_parameter("blend_strength", blend)

func _process(_delta):
	screen_tex = ImageTexture.create_from_image(get_viewport().get_texture().get_image())
	rect.material.set_shader_parameter("LAST_FRAME", screen_tex)
	pass
