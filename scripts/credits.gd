extends Control

const Ui := preload("res://scripts/ui.gd")

func _ready() -> void:
	Ui.fill_background(self)
	var safe := MarginContainer.new()
	safe.set_script(load("res://scripts/safe_margin.gd"))
	safe.set_anchors_preset(PRESET_FULL_RECT)
	add_child(safe)
	var col := VBoxContainer.new()
	col.size_flags_horizontal = SIZE_EXPAND_FILL
	col.size_flags_vertical = SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 12)
	safe.add_child(col)
	col.add_child(Ui.label("Credits & licenses", 48, Ui.CREAM, 8))
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll)
	var body := RichTextLabel.new()
	body.bbcode_enabled = false
	body.scroll_active = false
	body.fit_content = true
	body.size_flags_horizontal = SIZE_EXPAND_FILL
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_override("normal_font", Ui.FONT)
	body.add_theme_font_size_override("normal_font_size", 22)
	body.add_theme_color_override("default_color", Ui.INK)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("fff6e4", 0.94)
	style.set_corner_radius_all(18)
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 16
	style.content_margin_bottom = 16
	body.add_theme_stylebox_override("normal", style)
	body.text = _license_text()
	scroll.add_child(body)
	var back := Ui.button("Back", 280)
	back.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/menu.tscn"))
	col.add_child(back)

func _license_text() -> String:
	if FileAccess.file_exists("res://THIRD_PARTY_LICENSES.md"):
		var loaded := FileAccess.get_file_as_string("res://THIRD_PARTY_LICENSES.md")
		if not loaded.is_empty():
			return loaded
	return "Mallowskip. See THIRD_PARTY_LICENSES.md for Kenney, Lilita One, and Godot notices."
