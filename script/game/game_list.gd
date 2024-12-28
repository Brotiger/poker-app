extends Node

const default_size = 10
const endpoent = "/api/game"	

@export var auth_api: Node
@export var game_list_container: Node
@export var game_list_element: PackedScene
@export var search_string: Node

var from = 0
var size = default_size

var end = false
	
func get_games():
	if !self.end:
		var url = Config.http_api_url + self.endpoent + "?from=" + str(self.from) + "&size=" + str(self.size)
		if search_string.text != "":
			url += "&name=" + self.search_string.text
		print(url)
		var headers: Array[String] = ["Content-Type: application/json"]
		self.auth_api.send_request(url, HTTPClient.METHOD_GET, headers, "", Callable(self, "_on_http_request_completed"))

func clear_game_list():
	for child in self.game_list_container.get_children():
		child.queue_free()
		
func _on_http_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code == 401:
		self._hide()
	elif response_code == 200:
		self.from += self.size

		if len(data.games) < self.size:
			self.end = true
		
		for game in data.games:
			var game_list_element_instance = game_list_element.instantiate()
			self.game_list_container.add_child(game_list_element_instance)
			game_list_element_instance.set_info(game.name, game.count_players, game.max_players, game.with_password, game.status)

func _show() -> void:
	self.get_games()
	self.visible = true
	
func _hide() -> void:
	self.visible = false
	self.from = 0
	self.size = self.default_size
	self.end = false
	self.clear_game_list()
	self.search_string.text = ""

func _on_button_pressed() -> void:
	self.from = 0
	self.size = self.default_size
	self.end = false
	self.clear_game_list()
	self.get_games()
