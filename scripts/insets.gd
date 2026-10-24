extends RefCounted

## Safe-area insets in viewport pixels, plus a small margin so UI is not flush.

static func get_insets(viewport: Viewport) -> Vector4:
	var safe := DisplayServer.get_display_safe_area()
	var win := DisplayServer.window_get_size()
	var view := viewport.get_visible_rect().size
	if win.x <= 0 or win.y <= 0 or view.x <= 0.0 or view.y <= 0.0:
		return Vector4(28, 20, 28, 20)
	var sx := view.x / float(win.x)
	var sy := view.y / float(win.y)
	var left := safe.position.x * sx
	var top := safe.position.y * sy
	var right := (win.x - safe.end.x) * sx
	var bottom := (win.y - safe.end.y) * sy
	return Vector4(left + 20.0, top + 14.0, right + 20.0, bottom + 16.0)
