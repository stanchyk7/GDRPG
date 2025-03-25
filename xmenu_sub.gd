extends SubViewport

@onready var anim_player: AnimationPlayer = get_parent().get_node("AnimationPlayer")

func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	
func _on_child_entered_tree(_node: Node):
	get_parent().show()
	anim_player.play("dissolve_in")
	
func hide_menu():
	anim_player.play("dissolve_out")
	await anim_player.animation_finished
	get_child(-1).queue_free()
	get_parent().hide()
