extends Pawn
class_name PawnAnim

var switch_walk := false
@onready var animtree: AnimationTree =  $AnimationTree
@onready var walk_anim_length: float = $AnimationPlayer.get_animation("walk_down").length

func set_anim_direction(input_direction: Vector2i):
	animtree.set("parameters/StateMachine/Idle/blend_position", input_direction)
	animtree.set("parameters/StateMachine/Walk1/blend_position", input_direction)
	animtree.set("parameters/StateMachine/Walk0/blend_position", input_direction)
	
func tween_pos(new_pos: Vector2):
	animtree.set("parameters/TimeScale/scale", speed)
	animtree["parameters/StateMachine/playback"].start("Walk1" if switch_walk else "Walk0")
	animtree.advance(0)
	
	is_moving = true
	move_tween = create_tween()
	move_tween.tween_property(self,"position",new_pos,walk_anim_length/speed)
	move_tween.tween_callback(_tween_pos_done)
	move_tween.play()
	await move_tween.finished
	
func force_move_by(dir: Vector2i):
	set_anim_direction(dir)
	super(dir)

func _tween_pos_done():
	super()
	switch_walk = not switch_walk
