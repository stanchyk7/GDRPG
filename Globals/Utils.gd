extends Node

func snapped_pos(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos/Constants.tile_size))

func unsnapped_pos(pos: Vector2i) -> Vector2:
	return Vector2(pos)*Constants.tile_size+Constants.tile_size/2.0*Vector2.ONE
	
func world() -> Node2D:
	return get_node(Constants.base_path).get_child(-1)

func manager() -> PawnManager:
	return world().get_node("PawnManager")
