extends Node

const endpoint = "/api/game"	

@export var auth_api: Node

func _show() -> void:
	var url = Config.http_api_url + endpoint
	var headers: Array[String] = ["Content-Type: application/json"]
	auth_api.send_request(url, HTTPClient.METHOD_GET, headers, "", Callable(self, "_on_http_request_completed"))
	self.visible = true
	
func _hide() -> void:
	self.visible = false

func _on_http_request_completed(result, response_code, headers, body):
	if response_code == 401:
		self._hide()
