extends Node

const endpoint = "/api/auth/refresh"

@export var sing_in: Node
@export var notification_container: Node

var refresh_token = ""
var access_token = ""

var refresh_http_request: HTTPRequest
var current_http_request: HTTPRequest

var current_url: String
var current_method: HTTPClient.Method
var current_body: String
var current_headers: Array[String]
var current_callback: Callable

func _ready():
	self.current_http_request = HTTPRequest.new()
	self.add_child(self.current_http_request)
	self.current_http_request.request_completed.connect(self._current_http_request_completed)
	
	self.refresh_http_request = HTTPRequest.new()
	self.add_child(self.refresh_http_request)
	self.refresh_http_request.request_completed.connect(self._refresh_http_request_completed)

func send_request(url: String, method: HTTPClient.Method, headers: Array[String], body: String, callback: Callable):
	self.current_url = url
	self.current_method = method
	self.current_body = body
	self.current_headers = headers.duplicate()
	self.current_callback = callback
	
	headers.append("Authorization: Bearer " + self.access_token)

	self.current_http_request.request(self.current_url, headers, self.current_method, self.current_body)

func refresh_token_request():
	var body = JSON.stringify({
		"refreshToken": self.refresh_token,
	})
	
	var url = Config.http_api_url + endpoint
	var headers: Array[String] = [
		"Content-Type: application/json"
	]
	self.refresh_http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func _current_http_request_completed(result, response_code, headers, body):
	if response_code == 0:
		notification_container.create_notification("Сервер не доступен.", notification_container.error_notification)
	elif response_code >= 500:
		notification_container.create_notification("Ошибка сервера.", notification_container.error_notification)
	elif response_code >= 300 and response_code < 400:
		notification_container.create_notification("Ошибка связи с сервером.", notification_container.warn_notification)
	elif response_code == 401:
		self.refresh_token_request()
	else:
		self.current_callback.call(result, response_code, headers, body)
		
func _refresh_http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())

		self.access_token = data.access_token
		self.refresh_token = data.refresh_token
		
		self.send_request(self.current_url, self.current_method, self.current_headers, self.current_body, self.current_callback)
	else:
		if response_code == 401:
			self.sing_in.show()
			notification_container.create_notification("Истекло время сессии.", notification_container.warn_notification)
		self.current_callback.call(result, response_code, headers, body)
