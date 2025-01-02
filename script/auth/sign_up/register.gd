extends Node

const endpoint = "/api/auth/register"

@export var email_field: Node
@export var username_field: Node
@export var password_field: Node
@export var repeat_password_field: Node

@export var API: Node
@export var code_form: Node
@export var notification_container: Node

func _on_next_pressed() -> void:
	if self.password_field.text != self.repeat_password_field.text:
		self.password_field.Error()
		self.repeat_password_field.Error()
		return
	
	self.password_field.Default()
	self.repeat_password_field.Default()
	
	var url = Config.http_api_url + endpoint
	var headers: Array[String] = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"username": self.username_field.text,
		"email": self.email_field.text,
		"password": self.password_field.text,
	})
	
	API.send_request(url, HTTPClient.METHOD_POST, headers, body, Callable(self, "_on_http_request_completed"))

func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var data = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		self.code_form.email = email_field.text
		self._hide()
		self.code_form._show()
	elif response_code >= 400 and response_code < 500:
		print(data)
		if data.has("message"):
			self.notification_container.create_notification(data.message, notification_container.warn_notification)
		
		if data.has("errors"):
			if data.errors.has("username"):
				self.username_field.Error()
			else:
				self.username_field.Default()
				
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
	self.email_field.text = ""
	self.username_field.text = ""
	self.password_field.text = ""
	self.repeat_password_field.text = ""
	
	self.email_field.Default()
	self.username_field.Default()
	self.password_field.Default()
	self.repeat_password_field.Default()
	
	self.visible = false
