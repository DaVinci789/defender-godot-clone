extends KinematicBody2D

# https://ansimuz.itch.io/space-background

const LEFT_X_BOUNDARY := 275
const RIGHT_X_BOUNDARY := 1230

var velocity := Vector2()
var speed := 500

func get_player_input() -> void:
	var dir = Vector2(0,0)
	if Input.is_action_pressed("ui_left"):
		dir.x += -1
		position.x = lerp(position.x, RIGHT_X_BOUNDARY, 0.01)
	elif Input.is_action_pressed("ui_right"):
		dir.x += 1
		position.x = lerp(position.x, LEFT_X_BOUNDARY, 0.01)
	
	if Input.is_action_pressed("ui_up"):
		dir.y += -1
	elif Input.is_action_pressed("ui_down"):
		dir.y += 1
	
	if dir.x != 0:
		velocity.x = lerp(velocity.x, dir.x * speed, 0.01)
	else:
		velocity.x = lerp(velocity.x, 0, 0.1)
	velocity.y = dir.y * speed
	

func _process(delta):
	get_player_input()
	move_and_slide(Vector2(0, velocity.y))
	
	velocity.y = 0
	for node in $world.get_children():
		node.move_and_slide(-velocity)
