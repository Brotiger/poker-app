extends Node

func _on_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), .3)
	tween.tween_callback(Callable(self, "queue_free"))

func _on_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), .3)
	tween.tween_callback(Callable(self, "queue_free"))
