extends Button

@export var normal_error_border_color: Color
@export var disabled_error_border_color: Color

@export var normal_success_border_color: Color
@export var disabled_success_border_color: Color

var default_normal_border_color: Color
var default_disabled_border_color: Color

var normal_style_box: StyleBox
var disabled_style_box: StyleBox

func _ready() -> void:
	self.normal_style_box = get_theme_stylebox("normal").duplicate()
	self.disabled_style_box = get_theme_stylebox("disabled").duplicate()
	
	add_theme_stylebox_override("normal", self.normal_style_box)
	add_theme_stylebox_override("disabled", self.disabled_style_box)
	
	self.default_normal_border_color = self.normal_style_box.border_color
	self.default_disabled_border_color = self.disabled_style_box.border_color
	
func Default():
	self.normal_style_box.border_color = self.default_normal_border_color
	self.disabled_style_box.border_color = self.default_disabled_border_color

func Error():
	self.normal_style_box.border_color = self.normal_error_border_color
	self.disabled_style_box.border_color = self.disabled_error_border_color
	
func Success():
	self.normal_style_box.border_color = self.normal_success_border_color
	self.disabled_style_box.border_color = self.disabled_success_border_color
