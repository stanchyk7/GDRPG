extends Event
class_name Door

@export var map: String
@export var where: Vector2i
@export var sfx: String

func trigger_dialogue():
	if dialogue: super()
	#var string = "~ main\n\ndo Utils.transfer(\"%s\", Vector2%v, \"%s\", Vector2%v)" % [map, where, transition, dir]
	var string = "~ main\n\ndo Utils.transfer(\"%s\", Vector2%v)" % [map, where]
	var resource: DialogueResource = DialogueManager.create_resource_from_text(string)
	if not sfx.is_empty(): Utils.play_temp_audio(sfx)
	DialogueManager.show_dialogue_balloon(resource)
