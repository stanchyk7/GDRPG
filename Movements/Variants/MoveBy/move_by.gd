extends Movement
class_name MoveBy

@export var dir: Vector2i

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_dir: Vector2i = Vector2i.ZERO):
	dir = p_dir
