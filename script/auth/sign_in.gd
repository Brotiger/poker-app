extends Node

const endpoint = "/api/auth/login"

@export var email_field: Node
@export var password_field: Node

@export var home: Node
@export var notification_container: Node
@export var auth_api: Node
@export var api: Node

func _on_sign_in_pressed() -> void:
	var url = Config.http_api_url + endpoint
	var body = JSON.stringify({
		"email": email_field.text,
		"password": password_field.text
	})
	
	var headers: Array[String] = ["Content-Type: application/json"]
	self.api.send_request(url, HTTPClient.METHOD_POST, headers, body, Callable(self, "_on_http_request_completed"))

func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var data = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		self.auth_api.access_token = data.accessToken
		self.auth_api.refresh_token = data.refreshToken
			
		self._hide()
		self.home._show()
	elif response_code >= 400 and response_code < 500:
		if data.has("message"):
			self.notification_container.create_notification(data.message, notification_container.warn_notification)
			
		if response_code == 401:
			self.email_field.Error()
			self.email_field.Error()
		elif data.has("errors"):
			if data.errors.has("email"):
				self.email_field.Error()
			else:
				self.email_field.Default()
				
			if data.errors.has("password"):
				self.password_field.Error()
			else:
				self.password_field.Default()
				
func _show() -> void:
	self.visible = true

func _hide() -> void:
	self.visible = false
	self.password_field.Default()
	self.email_field.Default()
	self.email_field.text = ""
	self.password_field.text = ""
