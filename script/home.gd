extends Node

func _logout() -> void:
	API.access_token = ""
	API.refresh_token = ""
	
	self.visible = false

func _hide() -> void:
	self.visible = false

func _show() -> void:
	self.visible = true
