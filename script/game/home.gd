extends Node

const endpoint = "/api/auth/logout"	

@export var auth_api: Node
@export var sing_in: Node

func _logout() -> void:
	var url = Config.http_api_url + endpoint	
	var headers: Array[String] = ["Content-Type: application/json"]
	
	self.auth_api.send_request(url, HTTPClient.METHOD_POST, headers, "", Callable(self, "_on_http_request_completed"))
	
	self.auth_api.access_token = ""
	self.auth_api.refresh_token = ""
	
	self.visible = false

func _on_http_request_completed(result, response_code, headers, body):
	self._hide()
	self.sing_in.show()
	
func _hide() -> void:
	self.visible = false

func _show() -> void:
	self.visible = true
