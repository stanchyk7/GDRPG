extends Control

@onready var path = GameStateService.load_game_state(Constants.save_game_path)

func _ready():
	%new_game.grab_focus()
	%load_game.disabled = not path
	get_node(Constants.pause_path + "PanelContainer/MarginContainer/VBoxContainer/load").disabled = not path
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
