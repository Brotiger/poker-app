extends Node

@export var warn_notification: PackedScene
@export var error_notification: PackedScene

func create_notification(message: String, notification: PackedScene):
	var notification_instance = notification.instantiate()
	notification_instance.text = message

	$MarginContainer/VBoxContainer.add_child(notification_instance)
	$MarginContainer/VBoxContainer.move_child(notification_instance, 0)
