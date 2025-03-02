extends Camera2D

@export var target: Node2D
@export var lerp_self: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position,target.position,0.04) if lerp_self else target.position
