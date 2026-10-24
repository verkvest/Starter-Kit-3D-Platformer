extends Area3D

var _done := false

func _ready() -> void:
	add_to_group("goal")
	monitoring = true
	monitorable = false
	collision_mask = 1
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _done or not body.is_in_group("player"):
		return
	_done = true
	var play := get_tree().get_first_node_in_group("play_root")
	if play and play.has_method("on_goal"):
		play.on_goal()
