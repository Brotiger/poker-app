extends Node

@export var notification_container: Node

var http_request: HTTPRequest
var callback: Callable

func _ready():
	self.http_request = HTTPRequest.new()
	self.add_child(self.http_request)
	self.http_request.request_completed.connect(self._http_request_completed)

func send_request(url: String, method: HTTPClient.Method, headers: Array[String], body: String, callback: Callable):	
	self.callback = callback
	self.http_request.request(url, headers, method, body)

func _http_request_completed(result, response_code, headers, body):
	if response_code == 0:
		notification_container.create_notification("Сервер не доступен.", notification_container.error_notification)
	elif response_code >= 500:
		notification_container.create_notification("Ошибка сервера.", notification_container.error_notification)
	elif response_code >= 300 and response_code < 400:
		notification_container.create_notification("Ошибка связи с сервером.", notification_container.warn_notification)
	else:
		self.callback.call(result, response_code, headers, body)
