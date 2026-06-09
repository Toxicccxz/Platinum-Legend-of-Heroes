class_name ItemData
extends RefCounted

var id: String
var name: String
var description: String


func _init(item_id: String = "", item_name: String = "", item_description: String = "") -> void:
	id = item_id
	name = item_name
	description = item_description
