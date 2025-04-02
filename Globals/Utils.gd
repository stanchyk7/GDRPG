extends Node

@onready var base: SubViewport = get_node(Constants.base_path)
@onready var extra_menu: SubViewport = get_node(Constants.extra_menu_path)
@onready var extra_image: SubViewport = get_node(Constants.extra_image_path)
@onready var transition_player: AnimationPlayer = get_node(Constants.transition_path)
@onready var music_player: AudioStreamPlayer = get_node("/root/Game/MusicPlayer") # TODO find a better way to do this

var image_template = preload("res://Scenes/display_image.tscn")

func snapped_pos(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos/Constants.tile_size))

func unsnapped_pos(pos: Vector2i) -> Vector2:
	return Vector2(pos)*Constants.tile_size+Constants.tile_size/2.0*Vector2.ONE
	
func world() -> Node2D:
	return get_node(Constants.base_path).get_child(-1)

func manager() -> PawnManager:
	return world().get_node("PawnManager")
	
func transfer(map: String, where: Vector2i = Vector2i.MAX, override_map_base_dir = false):
	transition_player.play(Variables.transition+"_in")
	await transition_player.animation_finished
	if where != Vector2i.MAX: manager().get_pawn_by_name("Player").move_to(where, false)
	GameStateService.on_scene_transitioning()
	var wrld = load(map if override_map_base_dir else "res://Scenes/Maps/"+map+".tscn").instantiate()
	base.get_child(-1).free()
	base.add_child(wrld)
	transition_player.play(Variables.transition+"_out")
	await transition_player.animation_finished

func to_menu(what_menu: String):
	get_tree().paused = true
	var menu = load("res://Scenes/Menus/"+what_menu+".tscn").instantiate()
	extra_menu.add_child(menu)
	
func show_image(image: String):
	var img_src = load("res://Graphics/Images/"+image)
	var img = image_template.instantiate()
	img.texture = img_src
	img.position = Vector2(160,120)
	extra_image.add_child(img)
	img.name = image
	
func get_image(image: String):
	return extra_image.get_node(image)
	
func hide_image(img_name: String = ""):
	if img_name.is_empty():
		var children = extra_image.get_children()
		for child in children:
			child.queue_free()
	else:
		extra_image.get_node(img_name).queue_free()
		
func play_temp_audio(audio_in: String,node: Node = self,spatial: bool = false):
	var audio = load("res://Audio/" + audio_in)
	if audio:
		var audio_player = TemporaryAudioPlayer2D.new() if spatial else TemporaryAudioPlayer.new()
		audio_player.stream = audio
		audio_player.autoplay = true
		node.add_child(audio_player)

func force_play_music(audio_in: String,node: Node = self,spatial: bool = false):
	var audio = load("res://Audio/" + audio_in)
	if audio:
		var audio_player = AudioStreamPlayer2D.new() if spatial else AudioStreamPlayer.new()
		audio_player.stream = audio
		audio_player.autoplay = true
		node.add_child(audio_player)
	
func play_music(audio_in: String,node: Node = self,spatial: bool = false):
	if music_player.stream:
		if music_player.stream.resource_path != "res://Audio/" + audio_in:
			force_play_music(audio_in, node, spatial)
	else:
		force_play_music(audio_in, node, spatial)

func pause_music(audio: String, node: Node = self):
	node.get_node(audio).pause()
	
func stop_music(audio: String, node: Node = self):
	node.get_node(audio).stop()
	node.get_node(audio).queue_free()
