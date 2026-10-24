extends MarginContainer

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	get_viewport().size_changed.connect(_apply)
	_apply()

func _apply() -> void:
	var insets_script: Script = load("res://scripts/insets.gd")
	var pad: Vector4 = insets_script.get_insets(get_viewport())
	add_theme_constant_override("margin_left", int(pad.x))
	add_theme_constant_override("margin_top", int(pad.y))
	add_theme_constant_override("margin_right", int(pad.z))
	add_theme_constant_override("margin_bottom", int(pad.w))
