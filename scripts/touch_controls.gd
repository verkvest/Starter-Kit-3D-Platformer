extends Control

const BASE_R := 86.0
const KNOB_R := 36.0
const JUMP_R := 74.0
const FONT := preload("res://fonts/lilita_one_regular.ttf")

var _base := Vector2.ZERO
var _knob := Vector2.ZERO
var _jump := Vector2.ZERO
var _stick_index := -1
var _look_index := -1
var _jump_index := -1
var _look_last := Vector2.ZERO

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	resized.connect(_layout)
	_layout()

func _layout() -> void:
	var insets_script: Script = load("res://scripts/insets.gd")
	var pad: Vector4 = insets_script.get_insets(get_viewport())
	_base = Vector2(pad.x + BASE_R + 8.0, size.y - pad.w - BASE_R - 8.0)
	_jump = Vector2(size.x - pad.z - JUMP_R - 8.0, size.y - pad.w - JUMP_R - 4.0)
	if _stick_index < 0:
		_knob = _base
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused or not visible:
		return
	if event is InputEventScreenTouch:
		_touch(event)
	elif event is InputEventScreenDrag:
		_drag(event)

func _touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		if _jump_index < 0 and _hits_jump(event.position):
			_jump_index = event.index
			Input.action_press("jump")
			queue_redraw()
			get_viewport().set_input_as_handled()
		elif _stick_index < 0 and _in_stick_zone(event.position):
			_stick_index = event.index
			_apply_stick(event.position)
			get_viewport().set_input_as_handled()
		elif _look_index < 0 and not _hits_jump(event.position):
			_look_index = event.index
			_look_last = event.position
			get_viewport().set_input_as_handled()
	else:
		if event.index == _jump_index:
			_jump_index = -1
			Input.action_release("jump")
			queue_redraw()
		elif event.index == _stick_index:
			_stick_index = -1
			_knob = _base
			Touch.release_move()
			queue_redraw()
		elif event.index == _look_index:
			_look_index = -1

func _drag(event: InputEventScreenDrag) -> void:
	if event.index == _stick_index:
		_apply_stick(event.position)
		get_viewport().set_input_as_handled()
	elif event.index == _look_index:
		Touch.add_look(event.relative)
		_look_last = event.position
		get_viewport().set_input_as_handled()

func _in_stick_zone(point: Vector2) -> bool:
	return point.x < size.x * 0.46 and point.y > size.y * 0.28

func _hits_jump(point: Vector2) -> bool:
	return point.distance_to(_jump) <= JUMP_R * 1.35

func _apply_stick(point: Vector2) -> void:
	var offset := point - _base
	var length := offset.length()
	if length > BASE_R:
		offset = offset * (BASE_R / length)
	_knob = _base + offset
	var stick := offset / BASE_R
	Touch.set_move(stick)
	queue_redraw()

func _draw() -> void:
	if size.x < 10.0:
		return
	draw_circle(_base, BASE_R, Color(1, 1, 1, 0.22))
	draw_arc(_base, BASE_R, 0, TAU, 48, Color(1, 1, 1, 0.78), 5.0, true)
	draw_circle(_knob, KNOB_R, Color(1, 0.97, 0.9, 0.94))
	var jump_color := Color("e0b93a") if _jump_index >= 0 else Color("f4d35e")
	draw_circle(_jump, JUMP_R, jump_color)
	draw_arc(_jump, JUMP_R, 0, TAU, 48, Color("1d3a24", 0.35), 5.0, true)
	var text := "JUMP"
	var font_size := 32
	var text_size := FONT.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var baseline := _jump - Vector2(text_size.x * 0.5, -text_size.y * 0.32)
	draw_string(FONT, baseline, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color("1d3a24"))
