extends Control

var unpause = false

@onready var base = get_node(Constants.base_path)

func resume():
	unpause = false
	hide()
	get_tree().paused = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		if unpause:
			resume()
		else:
			unpause = true

func _on_save_pressed() -> void:
	GameStateService.save_game_state(Constants.save_game_path)
	$VBoxContainer/load.disabled = false

func _on_load_pressed() -> void:
	var path = GameStateService.load_game_state(Constants.save_game_path)
	print(path)
	if path:
		Utils.transfer(path, Vector2i.MAX, true)
	resume()

func _on_to_menu_pressed() -> void:
	Utils.transfer("../Menus/main_menu")
	resume()

func _on_resume_pressed() -> void:
	resume()
