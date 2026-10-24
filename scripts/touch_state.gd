extends Node

## Shared touch state. The on-screen controls write it; the camera reads it.

var look_delta := Vector2.ZERO
var stick_active := false

func add_look(delta_px: Vector2) -> void:
	look_delta += delta_px

func consume_look() -> Vector2:
	var delta := look_delta
	look_delta = Vector2.ZERO
	return delta

func release_move() -> void:
	if not stick_active:
		return
	stick_active = false
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("move_forward")
	Input.action_release("move_back")

func set_move(stick: Vector2) -> void:
	stick_active = true
	_axis("move_left", "move_right", stick.x)
	# Screen Y grows downward; forward is stick-up.
	_axis("move_forward", "move_back", -stick.y)

func release_all() -> void:
	release_move()
	Input.action_release("jump")
	look_delta = Vector2.ZERO

func _axis(negative: String, positive: String, value: float) -> void:
	if value > 0.12:
		Input.action_press(positive, clampf(value, 0.0, 1.0))
		Input.action_release(negative)
	elif value < -0.12:
		Input.action_press(negative, clampf(-value, 0.0, 1.0))
		Input.action_release(positive)
	else:
		Input.action_release(positive)
		Input.action_release(negative)
