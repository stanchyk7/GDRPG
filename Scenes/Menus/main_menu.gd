extends Control

func _on_new_game_pressed() -> void:
	GameStateService.new_game()
	var wrld = load("res://Scenes/Maps/world.tscn").instantiate()
	get_parent().add_child(wrld)
	queue_free()
	
func _on_load_game_pressed() -> void:
	var path = GameStateService.load_game_state("user://rpg_save_game.json")
	print(path)
	if path:
		GameStateService.on_scene_transitioning()
		var wrld = load(path).instantiate()
		get_parent().add_child(wrld)
		queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()
