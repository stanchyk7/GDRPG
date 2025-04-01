extends AudioStreamPlayer2D
class_name TemporaryAudioPlayer2D

func _ready() -> void:
	finished.connect(_on_finished)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_finished() -> void:
	queue_free()
