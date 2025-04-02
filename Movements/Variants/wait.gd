extends Movement
class_name Wait

@export var duration: float = 1.0

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_duration: float = 1.0):
	duration = p_duration
