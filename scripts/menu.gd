extends Control

const Ui := preload("res://scripts/ui.gd")

func _ready() -> void:
	Ui.fill_background(self)
	var safe := MarginContainer.new()
	safe.set_script(load("res://scripts/safe_margin.gd"))
	safe.set_anchors_preset(PRESET_FULL_RECT)
	add_child(safe)
	var center := CenterContainer.new()
	center.size_flags_horizontal = SIZE_EXPAND_FILL
	center.size_flags_vertical = SIZE_EXPAND_FILL
	safe.add_child(center)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 18)
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(col)
	col.add_child(Ui.label("Mallowskip", 84, Ui.CREAM, 12))
	col.add_child(Ui.label("A little hop across the knoll", 28, Ui.CREAM, 6))
	var play := Ui.button("Play")
	play.pressed.connect(func() -> void: Game.play_from_start())
	col.add_child(play)
	var levels := Ui.button("Levels")
	levels.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/level_select.tscn"))
	col.add_child(levels)
	var credits := Ui.button("Credits")
	credits.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/credits.tscn"))
	col.add_child(credits)
	if OS.get_environment("MALLOW_SCREENSHOT") == "1":
		_shot()

func _shot() -> void:
	for _i in 12:
		await get_tree().process_frame
	await Game.save_screenshot("menu")
	Game.level_index = 0
	get_tree().change_scene_to_file("res://scenes/play.tscn")
