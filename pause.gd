extends Control

var unpause = false

@onready var base = $/root/Game/SubViewportContainer/SubViewport

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
	GameStateService.save_game_state("user://rpg_save_game.json")

func _on_load_pressed() -> void:
	var path = GameStateService.load_game_state("user://rpg_save_game.json")
	print(path)
	if path:
		GameStateService.on_scene_transitioning()
		var wrld = load(path).instantiate()
		base.get_child(-1).free()
		base.add_child(wrld)
	resume()

func _on_to_world_pressed() -> void:
	Utils.transfer("world")
	resume()

func _on_to_world_2_pressed() -> void:
	Utils.transfer("world2")
	resume()

func _on_to_menu_pressed() -> void:
	var wrld = load("res://Scenes/Menus/main_menu.tscn").instantiate()
	base.get_child(-1).free()
	base.add_child(wrld)
	resume()

func _on_resume_pressed() -> void:
	resume()
