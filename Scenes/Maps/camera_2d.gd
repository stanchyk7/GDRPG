extends Camera2D

@export var target: Node2D
@export var lerp_self: bool
@export_range(0.0,0.1,0.01) var lerp_weight

@onready var target_path = target.get_path() if target else null

func _ready() -> void:
	$GameStateHelper.loading_data.connect(_on_loading_data)
	
func change_target(new_target: Node2D):
	target = new_target
	target_path = target.get_path()
	
func _on_loading_data(data: Dictionary):
	if target_path:
		change_target(get_node(target_path))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target: position = lerp(position,target.position,lerp_weight) if lerp_self else target.position
