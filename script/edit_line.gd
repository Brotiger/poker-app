extends LineEdit

@export var error_border_color: Color
var default_border_color: Color
var style_box: StyleBox

func _ready() -> void:
	style_box = get_theme_stylebox("normal").duplicate()
	add_theme_stylebox_override("normal", style_box)
	default_border_color = style_box.border_color
	
func Default():
	style_box.border_color = default_border_color

func Error():
	style_box.border_color = error_border_color
