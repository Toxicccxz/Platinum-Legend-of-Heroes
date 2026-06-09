class_name NPCData
extends RefCounted

var id: String
var name: String
var description: String
var dialogue: String


func _init(npc_id: String = "", npc_name: String = "", npc_description: String = "", npc_dialogue: String = "") -> void:
	id = npc_id
	name = npc_name
	description = npc_description
	dialogue = npc_dialogue
