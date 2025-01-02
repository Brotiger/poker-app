extends Node

const endpoint = "/api/auth/confirm_email"

@export var API: Node
@export var code_field: Node
@export var notification_container: Node
@export var sign_in_form: Node

var email: String

func _on_next_pressed() -> void:	
	var url = Config.http_api_url + endpoint
	var headers: Array[String] = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"email": self.email,
		"code": self.code_field.text,
	})
	
	API.send_request(url, HTTPClient.METHOD_POST, headers, body, Callable(self, "_on_http_request_completed"))

func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var data = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		self.notification_container.create_notification(data.message, notification_container.success_notification)
		self._hide()
		self.sign_in_form._show()
	elif response_code >= 400 and response_code < 500:
		if data.has("message"):
			self.notification_container.create_notification(data.message, notification_container.warn_notification)

		if data.has("errors"):
			if data.errors.has("code"):
				self.code_field.Error()
			else:
				self.code_field.Default()

func _show() -> void:
	self.visible = true

func _hide() -> void:
	self.email = ""
	self.code_field.text = ""
	
	self.code_field.Default()
	
	self.visible = false
