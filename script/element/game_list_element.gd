extends Node

@export var error_color: Color
@export var success_color: Color

var status_name = {
	"waiting": "Ожидание",
	"started": "Запущена"
} 

var room_name: String
var count_players: int
var max_players: int
var with_password: bool
var status: String

func set_info(room_name: String, count_players: int, max_players: int, with_password: bool, status: String):
	self.room_name = room_name
	self.count_players = count_players
	self.max_players = max_players
	self.with_password = with_password
	self.status = status
	
	$HBoxContainer/Name.text = self.room_name
	$HBoxContainer/Players.text = str(self.count_players) + "/" + str(self.max_players)
	
	if with_password == true:
		$HBoxContainer/Private.visible = true
		$HBoxContainer/Public.visible = false
	else:
		$HBoxContainer/Private.visible = false
		$HBoxContainer/Public.visible = true
	
	$HBoxContainer/Name.Success()
	$HBoxContainer/Players.Success()
	$HBoxContainer/Public.Success()
	$HBoxContainer/Private.Success()
		
	if self.max_players == self.count_players or self.status != "waiting":
		$HBoxContainer/Name.Error()
		$HBoxContainer/Players.Error()
		$HBoxContainer/Public.Error()
		$HBoxContainer/Private.Error()
