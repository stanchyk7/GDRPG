extends Pawn
class_name Event

@export var dialogue: DialogueResource
@export_enum('Action Button', 'Collision', 'Autorun') var trigger_method: int = 0

func _ready() -> void:
	if trigger_method == 2:
		trigger_dialogue()

func trigger_dialogue():
	DialogueManager.show_dialogue_balloon(dialogue)
