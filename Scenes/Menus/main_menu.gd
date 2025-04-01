extends Control

@onready var path = GameStateService.load_game_state("user://rpg_save_game.json")

func _ready():
	$VBoxContainer/new_game.grab_focus()
	$VBoxContainer/load_game.disabled = not path
	$/root/Game/CanvasLayer/pause/VBoxContainer/load.disabled = not path
	Utils.play_music("ambient1.ogg")

func _on_new_game_pressed() -> void:
	GameStateService.new_game()
	Utils.transfer("world")
	
func _on_load_game_pressed() -> void:
	print(path)
	if path:
		Utils.transfer(path, Vector2i.MAX, true)

func _on_quit_pressed() -> void:
	get_tree().quit()
