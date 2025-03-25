extends Control

@onready var intro = DialogueManager.create_resource_from_text("Map: Where do you wish to go?")
@onready var not_accessible = DialogueManager.create_resource_from_text("Map: This world isn't yet accessible.")

func _ready() -> void:
	get_tree().paused = true
	DialogueManager.show_dialogue_balloon(intro)

func _on_world_1_pressed() -> void:
	Utils.transfer("world", Vector2i(2,10))
	_on_exit_pressed()

func _on_world_2_pressed() -> void:
	Utils.transfer("world2", Vector2i(2,10))
	_on_exit_pressed()
	
func _on_world_3_pressed() -> void:
	DialogueManager.show_dialogue_balloon(not_accessible)

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_parent().hide_menu()
