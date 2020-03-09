extends KinematicBody2D

func _process(delta) -> void:
	move_and_slide(Vector2(100,0))
	global_position.x = wrapf(global_position.x, 0, OS.get_screen_size().x * 3)
