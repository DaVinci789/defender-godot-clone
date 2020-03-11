extends KinematicBody2D

# https://ansimuz.itch.io/space-background

# Player "Camera" Bounds
const LEFT_X_BOUNDARY := 275
const RIGHT_X_BOUNDARY := 1230

# Terrain Generation Stuff
# https://www.youtube.com/watch?v=YMN84VJ-uRU
const GRID_SIZE := 16.0
onready var terrain_line := $world/terrain/terrain_line
var base_level := -1.0
var flats := []
var last_point := Vector2.ZERO

var velocity := Vector2()
var speed := 500

func _ready():
	set_base_level()
	set_terrain()

func _process(delta):
	get_player_input()
	move_and_slide(Vector2(0, velocity.y))
	
	velocity.y = 0
	for node in $world.get_children():
		if not node.is_in_group("entity"):
			node.position.x -= 10
			continue 
		node.move_and_slide(-velocity)

### Terrain Stuff
func set_base_level() -> void:
	base_level = get_viewport_rect().size.y - GRID_SIZE
	terrain_line.position.y = base_level
	pass

func add_point(point: Vector2) -> void:
	terrain_line.add_point(point)
	if last_point and last_point.y == point.y:
		flats.append(point)
	last_point = point

func set_terrain() -> void:
	randomize()
	var pos := Vector2.ZERO
	add_point(pos)
	while pos.x < 5000 or abs(pos.y) > 0:
		pos.x += GRID_SIZE
		pos.y += (randi() % 3 - 1) * GRID_SIZE
		pos.y = clamp(pos.y, -300, 0)
		add_point(pos)
	pass

### Terrain stuff ends here

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
		velocity.x = lerp(velocity.x, dir.x * speed, 0.05)
	else:
		velocity.x = lerp(velocity.x, 0, 0.1)
	velocity.y = dir.y * speed
