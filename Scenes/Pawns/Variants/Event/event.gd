extends Walker
class_name Event

@export var dialogue: DialogueResource
@export_enum('Action Button', 'Collision', 'Autorun') var trigger_method: int = 0

func _ready() -> void:
	super()
	#change_sprite("icon2.svg") # For testing purposes
	if trigger_method == 2:
		
		# If an EventStateHelper is assigned to an Autorun Event, 
		# then it probably means the Event in question is scheduled to be deleted (e.g. via a dialogue),
		# and after it is, it will stay so.
		if get_node_or_null("EventStateHelper"):
			await $EventStateHelper.loading_data
			
		trigger_dialogue()

func trigger_dialogue():
	is_talking = true
	DialogueManager.show_dialogue_balloon(dialogue)
	await DialogueManager.dialogue_ended
	is_talking = false
