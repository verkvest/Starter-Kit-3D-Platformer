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
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 16)
	center.add_child(col)
	col.add_child(Ui.label("The knoll is yours", 64, Ui.CREAM, 10))
	col.add_child(Ui.label("This run: %d coins" % Game.run_coins, 32, Ui.CREAM, 6))
	var best_sum := 0
	var played := 0
	for value in Game.best:
		if int(value) >= 0:
			best_sum += int(value)
			played += 1
	col.add_child(Ui.label("Best haul: %d coins over %d levels" % [best_sum, played], 26, Ui.CREAM, 6))
	var again := Ui.button("Play again")
	again.pressed.connect(func() -> void: Game.play_from_start())
	col.add_child(again)
	var levels := Ui.button("Levels")
	levels.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/level_select.tscn"))
	col.add_child(levels)
	var menu := Ui.button("Menu")
	menu.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/menu.tscn"))
	col.add_child(menu)
