extends Node

func snapped_pos(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos/Constants.tile_size))
