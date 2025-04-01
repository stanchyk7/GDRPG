extends AudioStreamPlayer
class_name TemporaryAudioPlayer

func _ready() -> void:
	finished.connect(_on_finished)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_finished() -> void:
	queue_free()
