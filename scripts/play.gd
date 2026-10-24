extends Node3D

const Ui := preload("res://scripts/ui.gd")
const LEVELS := preload("res://scripts/level_data.gd")

var _coins := 0
var _coin_total := 0
var _cleared := false
var _coin_label: Label
var _hint: Label

@onready var player: CharacterBody3D = $Player
@onready var view: Node3D = $View
@onready var world: Node3D = $World

func _ready() -> void:
	_apply_mobile_look()
	var spec: Dictionary = LEVELS.level(Game.level_index)
	var spawn: Vector3 = LEVELS.build(world, Game.level_index)
	player.position = spawn
	player.velocity = Vector3.ZERO
	view.position = spawn
	_coin_total = get_tree().get_nodes_in_group("coin").size()
	_build_hud(str(spec["name"]), str(spec["hint"]))
	if player.has_signal("coin_collected"):
		player.coin_collected.connect(_on_coin)
	if player.has_signal("fell"):
		player.fell.connect(_on_fell)
	if OS.get_environment("MALLOW_SMOKE") == "1":
		_smoke()
	elif OS.get_environment("MALLOW_SCREENSHOT") == "1":
		_shot()

func on_goal() -> void:
	if _cleared:
		return
	_cleared = true
	Touch.release_all()
	Game.note_clear(_coins)
	Audio.play("res://sounds/coin.ogg")
	get_tree().paused = true
	_show_clear()

func _on_coin(count: int) -> void:
	_coins = count
	if _coin_label:
		_coin_label.text = "%d / %d" % [_coins, _coin_total]

func _on_fell() -> void:
	if _cleared:
		return
	Touch.release_all()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _apply_mobile_look() -> void:
	var method := RenderingServer.get_current_rendering_method()
	if method != "gl_compatibility":
		return
	$Sun.light_energy = 0.55
	$Sun.shadow_opacity = 0.85
	var env := $Environment.environment as Environment
	if env:
		env.background_energy_multiplier = 0.55

func _build_hud(level_name: String, hint: String) -> void:
	var safe := $UI/Safe
	var hud := Control.new()
	hud.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud.size_flags_vertical = Control.SIZE_EXPAND_FILL
	safe.add_child(hud)

	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.position = Vector2(8, 4)
	row.add_theme_constant_override("separation", 8)
	hud.add_child(row)
	var icon := TextureRect.new()
	icon.texture = preload("res://sprites/coin.png")
	icon.custom_minimum_size = Vector2(56, 56)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(icon)
	_coin_label = Ui.label("0 / %d" % _coin_total, 40, Ui.CREAM, 8)
	_coin_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	row.add_child(_coin_label)

	var title := Ui.label(level_name, 40, Ui.CREAM, 8)
	title.set_anchors_preset(Control.PRESET_CENTER_TOP)
	title.offset_top = 4
	title.offset_bottom = 64
	title.offset_left = -220
	title.offset_right = 220
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(title)

	_hint = Ui.label(hint, 24, Ui.CREAM, 6)
	_hint.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_hint.offset_top = 62
	_hint.offset_bottom = 110
	_hint.offset_left = -420
	_hint.offset_right = 420
	_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(_hint)
	var timer := get_tree().create_timer(5.5)
	timer.timeout.connect(func() -> void:
		if is_instance_valid(_hint):
			_hint.visible = false
	)

	var pause := Ui.button("Pause", 150)
	pause.custom_minimum_size = Vector2(150, 72)
	pause.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	pause.offset_left = -158
	pause.offset_top = 0
	pause.offset_right = 0
	pause.offset_bottom = 72
	pause.pressed.connect(_pause)
	hud.add_child(pause)

func _pause() -> void:
	if _cleared:
		return
	Touch.release_all()
	get_tree().paused = true
	_show_panel("Paused", "Take a breath.", "Resume", _resume, "Restart", _restart)

func _show_clear() -> void:
	var next_label := "Next" if Game.has_next() else "Finish"
	_show_panel(
		"Level clear",
		"%d / %d coins" % [_coins, _coin_total],
		next_label,
		func() -> void: Game.go_next(),
		"Levels",
		_to_levels
	)

func _show_panel(title: String, subtitle: String, primary: String, primary_action: Callable, secondary: String, secondary_action: Callable) -> void:
	var layer := CanvasLayer.new()
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	layer.layer = 20
	add_child(layer)
	var dim := ColorRect.new()
	dim.color = Color(0.05, 0.12, 0.08, 0.45)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(center)
	var panel := PanelContainer.new()
	var box_style := StyleBoxFlat.new()
	box_style.bg_color = Ui.CREAM
	box_style.set_corner_radius_all(28)
	box_style.content_margin_left = 36
	box_style.content_margin_right = 36
	box_style.content_margin_top = 28
	box_style.content_margin_bottom = 28
	panel.add_theme_stylebox_override("panel", box_style)
	center.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 16)
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(col)
	col.add_child(Ui.label(title, 52, Ui.INK))
	col.add_child(Ui.label(subtitle, 28, Ui.GRASS_DARK))
	var primary_button := Ui.button(primary, 320)
	primary_button.pressed.connect(primary_action)
	col.add_child(primary_button)
	var secondary_button := Ui.button(secondary, 320)
	secondary_button.pressed.connect(secondary_action)
	col.add_child(secondary_button)
	if title == "Paused":
		var levels := Ui.button("Levels", 320)
		levels.pressed.connect(_to_levels)
		col.add_child(levels)

func _resume() -> void:
	get_tree().paused = false
	for child in get_children():
		if child is CanvasLayer and child != $UI:
			child.queue_free()

func _restart() -> void:
	get_tree().paused = false
	Touch.release_all()
	get_tree().reload_current_scene()

func _to_levels() -> void:
	get_tree().paused = false
	Touch.release_all()
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _shot() -> void:
	for _i in 24:
		await get_tree().process_frame
	await Game.save_screenshot("gameplay")
	get_tree().quit()

func _smoke() -> void:
	for _i in 45:
		await get_tree().physics_frame
	var on_floor := player.is_on_floor()
	var goals := get_tree().get_nodes_in_group("goal").size()
	print("SMOKE level=%s name=%s floor=%s y=%.2f coins=%s goals=%s" % [
		Game.level_index, LEVELS.level(Game.level_index)["name"], on_floor, player.position.y, _coin_total, goals
	])
	if not on_floor or player.position.y < 0.2 or _coin_total < 1 or goals < 1:
		push_error("Smoke test failed on level %s" % Game.level_index)
		get_tree().quit(1)
		return
	if Game.level_index + 1 < LEVELS.level_count():
		Game.level_index += 1
		get_tree().reload_current_scene()
	else:
		print("SMOKE_OK")
		get_tree().quit(0)
