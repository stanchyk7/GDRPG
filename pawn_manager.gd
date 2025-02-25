extends Node2D
class_name PawnManager

@export var coll_manager: TileMapLayer
@export var pawn_coll_manager: TileMapLayer

func _ready() -> void:
	var tmaps = get_parent().get_node("Tilemaps").get_children() # Get tilemaps
	for tmap in tmaps:
		var cells = tmap.get_used_cells().filter(func(e): return tmap.get_cell_tile_data(e).get_custom_data("collision") == 1) # Get cells for collision
		for cell in cells:
			coll_manager.set_cell(cell, 0, Vector2i.ZERO) # Generate collision
	var pawns = get_children().filter(func(p): return p.collidable)
	for pawn in pawns:
		pawn_coll_manager.set_cell(get_converted_pos(pawn.position), 1, Vector2i.ZERO) # Generate collision

func get_converted_pos(pos: Vector2):
	return Vector2i(floor(pos/16.0))

func get_pawn_by_name(name: String):
	return get_children().filter(func(p): return p.name == name)[0]

func get_pawns_at(position: Vector2i):
	return get_children().filter(func(p): return get_converted_pos(p.position) == position)

func get_collidable_pawns_at(position: Vector2i):
	return get_children().filter(func(p): return get_converted_pos(p.position) == position and p.collidable)
