extends Node2D
class_name PawnManager

@export var coll_manager: TileMapLayer
@export var pawn_coll_manager: TileMapLayer

func _ready() -> void:
	GameStateService.state_load_completed.connect(_on_state_loaded)

func _on_state_loaded() -> void:
	var tmaps = get_parent().get_node("Tilemaps").get_children() # Get tilemaps
	for tmap in tmaps:
		var cells = tmap.get_used_cells().filter(func(e): return tmap.get_cell_tile_data(e).get_custom_data("collision") == 1) # Get cells for collision
		for cell in cells:
			coll_manager.set_cell(cell, 0, Vector2i.ZERO) # Generate collision
	var pawns = get_children().filter(func(p): return p.collidable)
	for pawn in pawns:
		pawn_coll_manager.set_cell(pawn.coll_pos, 1, Vector2i.ZERO) # Generate collision

func get_pawn_by_name(name: String):
	return get_children().filter(func(p): return p.name == name)[0]

func get_pawns_at(position: Vector2i):
	return get_children().filter(func(p): return Utils.snapped_pos(p.position) == position)

func get_collidable_pawns_at(position: Vector2i):
	return get_children().filter(func(p): return Utils.snapped_pos(p.position) == position and p.collidable)
