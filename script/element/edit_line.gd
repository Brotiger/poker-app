extends LineEdit

@export var normal_error_border_color: Color
@export var read_only_error_border_color: Color

@export var normal_success_border_color: Color
@export var read_only_success_border_color: Color

var default_normal_border_color: Color
var default_read_only_border_color: Color

var normal_style_box: StyleBox
var read_only_style_box: StyleBox

func _ready() -> void:
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
