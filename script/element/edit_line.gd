extends LineEdit

@export var next_focus: Control
@export var submit_button: Button

@export var normal_error_border_color: Color
@export var read_only_error_border_color: Color

@export var normal_success_border_color: Color
@export var read_only_success_border_color: Color

var default_normal_border_color: Color
var default_read_only_border_color: Color

var normal_style_box: StyleBox
var read_only_style_box: StyleBox

func _on_text_submitted(text: String) -> void:
	if next_focus:
		if next_focus:
			next_focus.grab_focus()
	elif submit_button:
		if submit_button:
			submit_button.emit_signal("pressed")
			
func _ready() -> void:
	self.connect("text_submitted", _on_text_submitted)
	
	self.normal_style_box = get_theme_stylebox("normal").duplicate()
	self.read_only_style_box = get_theme_stylebox("read_only").duplicate()
	
	add_theme_stylebox_override("normal", self.normal_style_box)
	add_theme_stylebox_override("read_only", self.read_only_style_box)
	
	self.default_normal_border_color = self.normal_style_box.border_color
	self.default_read_only_border_color = self.read_only_style_box.border_color
	
func Default():
	self.normal_style_box.border_color = self.default_normal_border_color
	self.read_only_style_box.border_color = self.default_read_only_border_color

func Error():
	self.normal_style_box.border_color = self.normal_error_border_color
	self.read_only_style_box.border_color = self.read_only_error_border_color
	
func Success():
	self.normal_style_box.border_color = self.normal_success_border_color
	self.read_only_style_box.border_color = self.read_only_success_border_color
