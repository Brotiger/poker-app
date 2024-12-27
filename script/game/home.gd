extends Node

func _logout() -> void:
	$AuthAPI.access_token = ""
	$AuthAPI.refresh_token = ""
	
	self.visible = false

func _hide() -> void:
	self.visible = false

func _show() -> void:
	self.visible = true
