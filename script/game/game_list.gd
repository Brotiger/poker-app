extends Node

const endpoent = "/api/game"	

@export var auth_api: Node
@export var game_list_container: Node
@export var game_list_element: PackedScene

var total: int

var from = 0
var size = 10

func _show() -> void:
	self.get_games()
	self.visible = true
	
func _hide() -> void:
	self.visible = false
	
func get_games():
	var url = Config.http_api_url + self.endpoent + "?from" + str(self.from) + "&size" + str(self.size)
	var headers: Array[String] = ["Content-Type: application/json"]
	self.auth_api.send_request(url, HTTPClient.METHOD_GET, headers, "", Callable(self, "_on_http_request_completed"))

func _on_http_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code == 401:
		self._hide()
	elif response_code == 200:
		for game in data.games:
			var game_list_element_instance = game_list_element.instantiate()
			self.game_list_container.add_child(game_list_element_instance)
			game_list_element_instance.set_info(game.name, game.countPlayers, game.maxPlayers, game.withPassword, game.status)
