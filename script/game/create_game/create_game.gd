extends Node

const endpoint = "/api/game"	

@export var notification_container: Node

@export var name_field: Node
@export var password_field: Node
@export var max_players_field: Node

@export var auth_api: Node

var valid_max_players_value = ["3", "4", "5", "6"]

func _show() -> void:
	self.visible = true
	
func _hide() -> void:
	self.name_field.Default()
	self.password_field.Default()
	self.max_players_field.Default()
	
	self.visible = false

func _on_next_pressed() -> void:
	self.max_players_field.Default()
	if !valid_max_players_value.has(max_players_field.text):
		self.max_players_field.Error()
		return
		
	var url = Config.http_api_url + endpoint	
	var headers: Array[String] = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"name": name_field.text,
		"password": password_field.text,
		"max_players": int(max_players_field.text),
	})
	
	self.auth_api.send_request(url, HTTPClient.METHOD_POST, headers, body, Callable(self, "_on_http_request_completed"))

func  _on_http_request_completed(result, response_code, headers, body) -> void:
	var data = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 401:
		self._hide()
	elif response_code >= 400 and response_code < 500:
		if data.has("message"):
			self.notification_container.create_notification(data.message, notification_container.warn_notification)
			
		if data.has("errors"):
			if data.errors.has("name"):
				self.name_field.Error()
			else:
				self.name_field.Default()
				
			if data.errors.has("password"):
				self.password_field.Error()
			else:
				self.password_field.Default()
			
			if data.errors.has("max_players"):
				self.max_players_field.Error()
			else:
				self.max_players_field.Default()
