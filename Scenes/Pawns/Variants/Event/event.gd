extends Pawn
class_name Event

@export var dialogue: DialogueResource
@export_enum('Action Button', 'Collision', 'Autorun') var trigger_method: int = 0

func _ready() -> void:
	#change_sprite("icon2.svg") For testing purposes
	if trigger_method == 2:
		trigger_dialogue()

func trigger_dialogue():
	is_talking = true
	DialogueManager.show_dialogue_balloon(dialogue)
	await DialogueManager.dialogue_ended
	is_talking = false
