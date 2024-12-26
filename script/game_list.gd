extends Node

func _show() -> void:
	var url = Config.http_api_url + "/api/game"
	var headers: Array[String] = [
		"Content-Type: application/json"
	]
	
	API.send_request(url, HTTPClient.METHOD_GET, "", headers, Callable(self, "asd"))
	self.visible = true
	
func _hide() -> void:
	self.visible = false

func asd(result, response_code, headers, body):
	print("+++")
