class_name LocationPanel
extends PanelContainer

@onready var location_name_label: Label = $MarginContainer/VBoxContainer/LocationNameLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var npc_label: Label = $MarginContainer/VBoxContainer/NPCLabel
@onready var exits_label: Label = $MarginContainer/VBoxContainer/ExitsLabel
@onready var items_label: Label = $MarginContainer/VBoxContainer/ItemsLabel


func refresh(game_state: GameState) -> void:
	var room: RoomData = game_state.get_current_room()
	if room == null:
		location_name_label.text = "Unknown"
		description_label.text = "No location data."
		npc_label.text = "NPCs: none"
		exits_label.text = "Exits: none"
		items_label.text = "Items: none"
		return

	var npc_names: Array[String] = game_state.get_current_npc_names()
	var item_names: Array[String] = game_state.get_current_item_names()

	location_name_label.text = room.name
	description_label.text = room.description
	npc_label.text = "NPCs: %s" % (", ".join(npc_names) if not npc_names.is_empty() else "none")
	exits_label.text = "Exits: %s" % game_state.get_current_exit_text()
	items_label.text = "Items: %s" % (", ".join(item_names) if not item_names.is_empty() else "none")
