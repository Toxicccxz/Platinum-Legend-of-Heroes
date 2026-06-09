class_name RoomData
extends RefCounted

var id: String
var name: String
var description: String
var grid_position: Vector2i
var exits: Dictionary = {}
var npcs: Array[NPCData] = []
var items: Array[ItemData] = []


func _init(room_id: String = "", room_name: String = "", room_description: String = "", room_position: Vector2i = Vector2i.ZERO) -> void:
	id = room_id
	name = room_name
	description = room_description
	grid_position = room_position


func add_exit(direction: String, room_id: String) -> void:
	exits[direction.to_lower()] = room_id


func get_exit_names() -> Array[String]:
	var exit_names: Array[String] = []
	for direction: String in exits.keys():
		exit_names.append(direction)
	exit_names.sort()
	return exit_names
