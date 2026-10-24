extends Node

const SAVE_PATH := "user://mallowskip_save.cfg"
const LEVELS := preload("res://scripts/level_data.gd")

var level_index := 0
var run_coins := 0
var unlocked := 1
var best: Array = []

func _ready() -> void:
	best.resize(LEVELS.level_count())
	best.fill(-1)
	_load()
	if OS.get_environment("MALLOW_SCREENSHOT") == "1":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(844, 390))

func level_count() -> int:
	return LEVELS.level_count()

func level_name(index: int) -> String:
	return str(LEVELS.level(index)["name"])

func play_from_start() -> void:
	run_coins = 0
	level_index = 0
	_go_play()

func play_level(index: int) -> void:
	if index < 0 or index >= unlocked:
		return
	run_coins = 0
	level_index = index
	_go_play()

func note_clear(coins: int) -> void:
	best[level_index] = maxi(int(best[level_index]), coins)
	run_coins += coins
	unlocked = maxi(unlocked, mini(level_index + 2, level_count()))
	_save()

func has_next() -> bool:
	return level_index + 1 < level_count()

func go_next() -> void:
	get_tree().paused = false
	if has_next():
		level_index += 1
		_go_play()
	else:
		get_tree().change_scene_to_file("res://scenes/end.tscn")

func _go_play() -> void:
	get_tree().paused = false
	Touch.release_all()
	get_tree().change_scene_to_file("res://scenes/play.tscn")

func save_screenshot(shot_name: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var win := DisplayServer.window_get_size()
	if win.x > 8 and win.y > 8 and image.get_width() != win.x:
		image.resize(win.x, win.y, Image.INTERPOLATE_LANCZOS)
	var dir := OS.get_environment("MALLOW_SHOT_DIR")
	if dir.is_empty():
		dir = ProjectSettings.globalize_path("res://build/screenshots")
	DirAccess.make_dir_recursive_absolute(dir)
	var path := dir.path_join(shot_name + ".png")
	var err := image.save_png(path)
	print("SCREENSHOT %s %s" % [path, err])

func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	unlocked = clampi(int(cfg.get_value("progress", "unlocked", 1)), 1, level_count())
	var stored: Array = cfg.get_value("progress", "best", [])
	for i in mini(stored.size(), best.size()):
		best[i] = int(stored[i])

func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "unlocked", unlocked)
	cfg.set_value("progress", "best", best)
	cfg.save(SAVE_PATH)
