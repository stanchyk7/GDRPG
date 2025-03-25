extends Sprite2D
class_name DisplayImage

func tween_size(new_scale: Vector2, dur: float, from:Vector2=scale):
	scale = from
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", new_scale, dur)
	await tween.finished

func tween_pos(new_pos: Vector2, dur: float, from:Vector2=position):
	position=from
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_pos, dur)
	await tween.finished

func tween_rot(new_rot: float, dur: float, from:float=rotation_degrees):
	rotation_degrees = from 
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", new_rot, dur)
	await tween.finished

func tween_alpha(new_alpha: float, dur: float, from:float=material.get_shader_parameter("opacity")):
	material.set_shader_parameter("opacity",from)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "material:shader_parameter/opacity", new_alpha, dur)
	await tween.finished

func tween_dissolve(new_dissolve: float, dur: float, from:float=material.get_shader_parameter("fill")):
	material.set_shader_parameter("fill",from)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "material:shader_parameter/fill", new_dissolve, dur)
	await tween.finished
