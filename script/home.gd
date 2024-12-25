extends Node

func _logout() -> void:
	Auth.accessToken = ""
	Auth.refreshToken = ""
	
	self.visible = false

func _hide() -> void:
	self.visible = false

func _show() -> void:
	self.visible = true
