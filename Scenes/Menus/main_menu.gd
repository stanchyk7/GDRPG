extends Control

func _ready():
	$VBoxContainer/new_game.grab_focus()

func _on_new_game_pressed() -> void:
	GameStateService.new_game()
	Utils.transfer("world")
	
func _on_load_game_pressed() -> void:
	var path = GameStateService.load_game_state("user://rpg_save_game.json")
	print(path)
	if path:
		Utils.transfer(path, Vector2i.MAX, true)

func _on_quit_pressed() -> void:
	get_tree().quit()
