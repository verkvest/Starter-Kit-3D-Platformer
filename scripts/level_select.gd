extends Control

const Ui := preload("res://scripts/ui.gd")
const LEVELS := preload("res://scripts/level_data.gd")

func _ready() -> void:
	Ui.fill_background(self)
	var safe := MarginContainer.new()
	safe.set_script(load("res://scripts/safe_margin.gd"))
	safe.set_anchors_preset(PRESET_FULL_RECT)
	add_child(safe)
	var col := VBoxContainer.new()
	col.size_flags_horizontal = SIZE_EXPAND_FILL
	col.size_flags_vertical = SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 18)
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	safe.add_child(col)
	col.add_child(Ui.label("Levels", 64, Ui.CREAM, 10))
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 16)
	row.size_flags_horizontal = SIZE_EXPAND_FILL
	col.add_child(row)
	for i in LEVELS.level_count():
		row.add_child(_card(i))
	var back := Ui.button("Back", 280)
	back.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/menu.tscn"))
	col.add_child(back)

func _card(index: int) -> Control:
	var locked := index >= Game.unlocked
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color("fff6e4") if not locked else Color("d5ddd6")
	style.set_corner_radius_all(20)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 16
	style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", style)
	panel.custom_minimum_size = Vector2(200, 250)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_child(col)
	col.add_child(Ui.label(str(index + 1), 48, Ui.GRASS_DARK))
	col.add_child(Ui.label(str(LEVELS.level(index)["name"]), 26, Ui.INK))
	var best := int(Game.best[index]) if index < Game.best.size() else -1
	var best_text := "Best %d" % best if best >= 0 else "Not yet"
	if locked:
		best_text = "Locked"
	col.add_child(Ui.label(best_text, 22, Ui.GRASS_DARK))
	var button := Ui.button("Play" if not locked else "Locked", 160)
	button.custom_minimum_size = Vector2(160, 68)
	button.disabled = locked
	button.pressed.connect(func() -> void: Game.play_level(index))
	col.add_child(button)
	return panel
