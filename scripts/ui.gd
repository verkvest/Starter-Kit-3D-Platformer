extends RefCounted

const FONT := preload("res://fonts/lilita_one_regular.ttf")

const INK := Color("1d3a24")
const CREAM := Color("fff6e4")
const GOLD := Color("f4d35e")
const GOLD_DOWN := Color("e0b93a")
const SKY := Color("7ec8ea")
const SKY_DEEP := Color("4aa3d8")
const GRASS := Color("3d9a4c")
const GRASS_DARK := Color("1f6b32")
const LOCKED := Color("c5d0c8")

static func label(text: String, size: int, color: Color = CREAM, outline: int = 0) -> Label:
	var node := Label.new()
	node.text = text
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var settings := LabelSettings.new()
	settings.font = FONT
	settings.font_size = size
	settings.font_color = color
	if outline > 0:
		settings.outline_size = outline
		settings.outline_color = GRASS_DARK
	settings.shadow_color = Color(0, 0, 0, 0.28)
	settings.shadow_offset = Vector2(0, 3)
	node.label_settings = settings
	return node

static func button(text: String, wide := 360.0) -> Button:
	var node := Button.new()
	node.text = text
	node.custom_minimum_size = Vector2(wide, 84)
	node.focus_mode = Control.FOCUS_NONE
	node.add_theme_font_override("font", FONT)
	node.add_theme_font_size_override("font_size", 34)
	node.add_theme_color_override("font_color", INK)
	node.add_theme_color_override("font_hover_color", INK)
	node.add_theme_color_override("font_pressed_color", INK)
	node.add_theme_color_override("font_disabled_color", Color("5c6b62"))
	node.add_theme_stylebox_override("normal", _box(GOLD))
	node.add_theme_stylebox_override("hover", _box(GOLD.lightened(0.08)))
	node.add_theme_stylebox_override("pressed", _box(GOLD_DOWN))
	node.add_theme_stylebox_override("disabled", _box(LOCKED))
	node.add_theme_stylebox_override("focus", _box(GOLD))
	return node

static func _box(color: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.set_corner_radius_all(22)
	box.content_margin_left = 18
	box.content_margin_right = 18
	box.content_margin_top = 8
	box.content_margin_bottom = 8
	box.shadow_color = Color(0, 0, 0, 0.2)
	box.shadow_size = 6
	box.shadow_offset = Vector2(0, 3)
	return box

static func fill_background(parent: Control) -> void:
	var sky := ColorRect.new()
	sky.color = SKY
	sky.set_anchors_preset(Control.PRESET_FULL_RECT)
	sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(sky)
	var hill := ColorRect.new()
	hill.color = GRASS
	hill.anchor_left = 0.0
	hill.anchor_top = 0.62
	hill.anchor_right = 1.0
	hill.anchor_bottom = 1.0
	hill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(hill)
	var band := ColorRect.new()
	band.color = GRASS_DARK
	band.anchor_left = 0.0
	band.anchor_top = 0.62
	band.anchor_right = 1.0
	band.anchor_bottom = 0.66
	band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(band)
