extends Node

@export var max_players_field: LineEdit

func _on_button_pressed(players: int) -> void:
	self.max_players_field.text = str(players)
