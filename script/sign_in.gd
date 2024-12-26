extends Node

@export var config: Node
@export var http_request: HTTPRequest

@export var email_field: Node
@export var password_field: Node

@export var home: Node
@export var notification_container: Node
@export var warn_notification: PackedScene
@export var error_notification: PackedScene

var endpoint = "/api/auth/login"
	
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 0:
		create_notification("Сервер не доступен.", error_notification)
	elif response_code >= 500:
		create_notification("Ошибка сервера.", error_notification)
	else:
		var data = JSON.parse_string(body.get_string_from_utf8())
		
		if response_code == 200:
			Auth.accessToken = data.accessToken
			Auth.refreshToken = data.refreshToken
			
			self._hide()
			home.visible = true
		elif response_code >= 300 and response_code < 400:
			create_notification("Ошибка связи с сервером.", warn_notification)
		elif response_code >= 400 and response_code < 500:
			if data.has("message"):
				create_notification(data.message, warn_notification)
				
			print(data)
			if response_code == 401:
				email_field.Error()
				email_field.Error()
			elif data.has("errors"):
				if data.errors.has("email"):
					print("+++")
					email_field.Error()
				else:
					email_field.Default()
					
				if data.errors.has("password"):
					password_field.Error()
				else:
					password_field.Default()

func _on_sign_in_pressed() -> void:
	var url = config.http_api_url + endpoint
	var body = JSON.stringify({
		"email": email_field.text,
		"password": password_field.text
	})
	
	http_request.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)

func create_notification(message: String, notification: PackedScene):
	var notification_instance = notification.instantiate()
	notification_instance.text = message

	notification_container.add_child(notification_instance)
	notification_container.move_child(notification_instance, 0)

func _show() -> void:
	self.visible = true

func _hide() -> void:
	self.visible = false
	password_field.Default()
	email_field.Default()
	email_field.text = ""
	password_field.text = ""
