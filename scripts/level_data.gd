extends RefCounted

const PIECES := {
	"small": preload("res://objects/platform.tscn"),
	"medium": preload("res://objects/platform_medium.tscn"),
	"round": preload("res://objects/platform_grass_large_round.tscn"),
	"fall": preload("res://objects/platform_falling.tscn"),
	"brick": preload("res://objects/brick.tscn"),
	"coin": preload("res://objects/coin.tscn"),
	"cloud": preload("res://objects/cloud.tscn"),
	"grass": preload("res://models/grass.glb"),
	"tuft": preload("res://models/grass-small.glb"),
	"goal": preload("res://models/flag.glb"),
}

const GOAL_SCRIPT := preload("res://scripts/goal.gd")

# Meadow keeps the original starter layout. The other four are built from the same CC0 pieces.
const LEVELS := [
	{
		"name": "Meadow",
		"hint": "Reach the flag. Swipe the right side to look around.",
		"spawn": Vector3(0, 0.55, 0),
		"pieces": [
			["small", 0.0, 0.0, 0.0, -6.7],
			["small", -15.0, 0.0, 4.0, -6.7],
			["small", -21.925, 0.347, -2.684, -6.7],
			["small", -22.076, 1.513, -4.765, 12.1],
			["small", -3.0, 2.0, -3.0, 0.0],
			["small", -3.0, 3.0, -5.0, -14.9],
			["medium", -3.0, 0.0, 0.0, 5.0],
			["medium", -5.0, 0.0, 4.0, 5.7],
			["medium", -14.942, 0.992, 0.128, -21.6],
			["medium", 0.0, 3.0, -6.0, 0.0],
			["fall", -9.0, 0.419, 4.0, 10.0],
			["fall", -12.0, -0.315, 4.0, -6.0],
			["fall", -11.753, 1.830, -2.306, 20.0],
			["round", -7.0, 1.0, -2.0, 0.0],
			["round", -19.310, 1.0, 2.832, 0.0],
			["goal", 0.0, 3.481, -6.0, -45.0],
			["coin", -3.0, 0.635, 0.0, 0.0],
			["coin", -5.0, 0.635, 4.0, 0.0],
			["coin", -7.044, 1.970, -0.330, 0.0],
			["coin", -7.044, 1.970, -1.330, 0.0],
			["coin", -7.044, 1.970, -2.330, 0.0],
			["coin", -11.773, 2.549, -2.282, 0.0],
			["coin", -14.811, 1.689, 0.329, 0.0],
			["coin", -14.811, 2.689, 0.329, 0.0],
			["coin", -14.965, 0.802, 3.994, 0.0],
			["coin", 0.0, 5.0, -6.0, 0.0],
			["coin", -6.709, 5.339, -2.004, 0.0],
			["coin", -18.979, 1.775, 2.862, 0.0],
			["coin", -22.117, 2.561, -4.757, 0.0],
			["coin", -22.117, 3.321, -4.757, 0.0],
			["brick", -3.119, 1.986, -0.089, 0.0],
			["brick", -6.764, 3.215, -2.020, -31.2],
			["brick", -19.034, 3.215, 2.869, 20.1],
			["cloud", 1.55, 1.11, -2.67, 0.0],
			["cloud", 3.34, 1.37, -4.19, 0.0],
			["cloud", -10.58, 2.04, -7.94, 0.0],
			["cloud", -9.47, 2.04, 11.51, 0.0],
			["cloud", -9.20, 2.80, 13.74, 0.0],
			["cloud", -14.30, 2.04, -8.24, 0.0],
			["cloud", -14.15, 2.04, 10.07, 0.0],
		],
	},
	{
		"name": "Brick Rise",
		"hint": "Hop up the steps. Jump into a brick from below.",
		"spawn": Vector3(0, 0.55, 0),
		"pieces": [
			["round", 0.0, 0.0, 0.0, 0.0],
			["coin", 0.6, 1.15, 0.8, 0.0],
			["tuft", -1.4, 0.5, 1.1, 20.0],
			["small", 0.0, 0.75, -4.8, 0.0],
			["coin", 0.0, 1.7, -4.8, 0.0],
			["brick", 0.0, 2.75, -4.8, 0.0],
			["coin", 0.0, 2.9, -4.8, 0.0],
			["small", 2.2, 1.5, -8.2, 8.0],
			["coin", 2.2, 2.45, -8.2, 0.0],
			["small", 2.2, 2.25, -11.6, -6.0],
			["coin", 2.2, 3.2, -11.6, 0.0],
			["medium", 0.6, 3.0, -14.6, 0.0],
			["coin", 0.2, 3.95, -14.2, 0.0],
			["coin", 1.1, 3.95, -15.0, 0.0],
			["brick", 0.6, 5.0, -14.6, 0.0],
			["round", -1.8, 3.75, -18.4, 0.0],
			["goal", -1.8, 4.25, -18.4, 25.0],
			["coin", -0.6, 4.7, -17.8, 0.0],
			["cloud", 7.0, 4.5, -6.0, 0.0],
			["cloud", -8.0, 5.5, -12.0, 0.0],
			["grass", 1.5, 0.5, -0.4, 40.0],
		],
	},
	{
		"name": "Crumble Run",
		"hint": "Keep running. The tan platforms fall away.",
		"spawn": Vector3(0, 0.55, 0),
		"pieces": [
			["round", 0.0, 0.0, 0.0, 0.0],
			["coin", 0.8, 1.15, 0.4, 0.0],
			["coin", -0.7, 1.15, -0.5, 0.0],
			["fall", 0.0, 0.0, -4.4, 0.0],
			["coin", 0.0, 1.05, -4.4, 0.0],
			["fall", 0.0, 0.0, -6.7, 0.0],
			["fall", 0.0, 0.1, -9.0, 0.0],
			["coin", 0.0, 1.15, -9.0, 0.0],
			["medium", 0.0, 0.25, -12.0, 0.0],
			["coin", -0.6, 1.2, -11.6, 0.0],
			["coin", 0.6, 1.2, -12.4, 0.0],
			["tuft", 1.1, 0.75, -11.4, 0.0],
			["fall", 0.0, 0.25, -14.8, 0.0],
			["fall", 0.0, 0.2, -17.1, 0.0],
			["coin", 0.0, 1.25, -17.1, 0.0],
			["round", 0.0, 0.4, -20.6, 0.0],
			["goal", 0.0, 0.9, -20.6, 0.0],
			["coin", 1.0, 1.35, -20.0, 0.0],
			["cloud", 6.5, 3.2, -8.0, 0.0],
			["cloud", -7.0, 3.6, -16.0, 0.0],
		],
	},
	{
		"name": "High Garden",
		"hint": "The tall island needs a double jump.",
		"spawn": Vector3(0, 0.55, 0),
		"pieces": [
			["medium", 0.0, 0.0, 0.0, 0.0],
			["coin", 0.0, 1.05, 0.4, 0.0],
			["tuft", 1.0, 0.5, 0.8, 15.0],
			["small", 0.0, 0.7, -4.0, 0.0],
			["coin", 0.0, 1.65, -4.0, 0.0],
			["small", 1.6, 1.4, -6.8, 10.0],
			["coin", 1.6, 2.35, -6.8, 0.0],
			["brick", 1.6, 3.4, -6.8, 0.0],
			["small", 1.6, 1.4, -10.2, 0.0],
			["coin", 1.6, 2.35, -10.2, 0.0],
			["round", 0.2, 2.65, -13.4, 0.0],
			["coin", -0.6, 3.6, -13.0, 0.0],
			["coin", 0.9, 3.6, -13.8, 0.0],
			["small", -2.2, 3.35, -16.8, -8.0],
			["coin", -2.2, 4.3, -16.8, 0.0],
			["medium", -2.2, 4.05, -20.2, 0.0],
			["goal", -2.2, 4.55, -20.2, -20.0],
			["coin", -1.2, 5.0, -19.6, 0.0],
			["coin", -3.0, 5.0, -20.6, 0.0],
			["cloud", 8.0, 4.0, -8.0, 0.0],
			["cloud", -7.5, 6.0, -14.0, 0.0],
			["grass", -0.8, 0.5, 0.6, -30.0],
		],
	},
	{
		"name": "Summit",
		"hint": "Steps, falling bridges, then one last double jump.",
		"spawn": Vector3(0, 0.55, 0),
		"pieces": [
			["round", 0.0, 0.0, 0.0, 0.0],
			["coin", 0.9, 1.15, 0.5, 0.0],
			["small", 0.0, 0.7, -4.6, 0.0],
			["coin", 0.0, 1.65, -4.6, 0.0],
			["small", 0.0, 1.4, -8.0, 0.0],
			["coin", 0.0, 2.35, -8.0, 0.0],
			["fall", 0.0, 1.4, -10.6, 0.0],
			["fall", 0.0, 1.45, -12.8, 0.0],
			["coin", 0.0, 2.5, -12.8, 0.0],
			["fall", 0.0, 1.5, -15.0, 0.0],
			["medium", 0.0, 1.7, -18.0, 0.0],
			["coin", -0.7, 2.65, -17.6, 0.0],
			["coin", 0.7, 2.65, -18.4, 0.0],
			["brick", 0.0, 3.7, -18.0, 0.0],
			["coin", 0.0, 3.85, -18.0, 0.0],
			["small", 2.2, 2.4, -21.2, 12.0],
			["coin", 2.2, 3.35, -21.2, 0.0],
			["round", 1.0, 3.65, -24.2, 0.0],
			["coin", 0.2, 4.6, -23.6, 0.0],
			["coin", 1.8, 4.6, -24.6, 0.0],
			["small", -1.6, 4.35, -27.6, 0.0],
			["coin", -1.6, 5.3, -27.6, 0.0],
			["round", -3.4, 5.05, -31.4, 0.0],
			["goal", -3.4, 5.55, -31.4, 35.0],
			["coin", -2.4, 6.0, -30.8, 0.0],
			["coin", -4.2, 6.0, -31.8, 0.0],
			["cloud", 8.0, 5.0, -10.0, 0.0],
			["cloud", -9.0, 7.0, -20.0, 0.0],
			["cloud", 6.0, 8.0, -28.0, 0.0],
			["grass", 1.6, 0.5, 1.2, 10.0],
		],
	},
]

static func level_count() -> int:
	return LEVELS.size()

static func level(index: int) -> Dictionary:
	return LEVELS[index]

static func build(parent: Node3D, index: int) -> Vector3:
	var spec: Dictionary = LEVELS[index]
	for entry in spec["pieces"]:
		var type := str(entry[0])
		var node: Node3D = PIECES[type].instantiate()
		node.position = Vector3(entry[1], entry[2], entry[3])
		node.rotation.y = deg_to_rad(float(entry[4]))
		if type == "goal":
			var area := Area3D.new()
			area.set_script(GOAL_SCRIPT)
			var shape := CollisionShape3D.new()
			var box := BoxShape3D.new()
			box.size = Vector3(2.2, 2.4, 2.2)
			shape.shape = box
			shape.position = Vector3(0, 1.1, 0)
			area.add_child(shape)
			node.add_child(area)
		parent.add_child(node)
	return spec["spawn"]
