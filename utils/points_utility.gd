class_name PointUtility
extends Node


static func display_points(points: int, node: Node, marker: Marker2D) -> void:
	var fl = FlyawayLabel.new()
	node.add_child(fl)
	var position = marker.global_position
	fl.points = points
	fl.global_position = position
