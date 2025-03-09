extends Node2D
class_name PawnAnim

var switch_walk := false
@onready var animtree: AnimationTree =  $AnimationTree
@onready var walk_anim_length: float = $AnimationPlayer.get_animation("walk_down").length
@export var parent: Node2D

func set_anim_direction(input_direction: Vector2i):
	parent.cur_direction = input_direction
	animtree.set("parameters/StateMachine/Idle/blend_position", input_direction)
	animtree.set("parameters/StateMachine/Walk1/blend_position", input_direction)
	animtree.set("parameters/StateMachine/Walk0/blend_position", input_direction)
	
func tween_pos(new_pos: Vector2):
	animtree.set("parameters/TimeScale/scale", parent.speed)
	animtree["parameters/StateMachine/playback"].start("Walk1" if switch_walk else "Walk0")
	animtree.advance(0)
	
	parent.is_moving = true
	parent.move_tween = create_tween()
	parent.move_tween.tween_property(parent,"position",new_pos,walk_anim_length/parent.speed)
	parent.move_tween.tween_callback(_tween_pos_done)
	parent.move_tween.play()
	await parent.move_tween.finished
	
func force_move_by(dir: Vector2i):
	set_anim_direction(dir)
	parent.force_move_by(dir)

func _tween_pos_done():
	parent._tween_pos_done()
	switch_walk = not switch_walk
