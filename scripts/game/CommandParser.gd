class_name CommandParser
extends RefCounted

const MOVEMENT_ALIASES: Dictionary = {
	"n": "north",
	"north": "north",
	"s": "south",
	"south": "south",
	"e": "east",
	"east": "east",
	"w": "west",
	"west": "west",
}

var game_state: GameState


func _init(state: GameState) -> void:
	game_state = state


func parse(command_text: String) -> Array[String]:
	var clean_command: String = command_text.strip_edges()
	if clean_command.is_empty():
		return ["Type a command, or try 'help'."]

	var lower_command: String = clean_command.to_lower()
	var parts: PackedStringArray = lower_command.split(" ", false)
	var verb: String = parts[0]

	if MOVEMENT_ALIASES.has(verb):
		var direction: String = MOVEMENT_ALIASES[verb] as String
		var move_response: String = game_state.move_player(direction)
		var responses: Array[String] = [move_response]
		if not move_response.begins_with("You cannot"):
			responses.append(game_state.describe_current_room())
		return responses

	match verb:
		"look":
			return [game_state.describe_current_room()]
		"map":
			return [_get_map_response()]
		"inventory", "inv", "i":
			return [_get_inventory_response()]
		"talk":
			return [_talk_to_npc(clean_command)]
		"help":
			return [_get_help_response()]
		_:
			return ["I do not understand '%s'. Try 'help' for available commands." % clean_command]


func _talk_to_npc(command_text: String) -> String:
	var npc_name: String = command_text.substr(4).strip_edges()
	if npc_name.is_empty():
		return "Talk to whom? Try 'talk innkeeper'."

	var npc: NPCData = game_state.find_npc_in_current_room(npc_name)
	if npc == null:
		return "There is no '%s' here to talk to." % npc_name

	return "%s says: \"%s\"" % [npc.name, npc.dialogue]


func _get_inventory_response() -> String:
	if game_state.player.inventory.is_empty():
		return "Your inventory is empty."

	var item_names: Array[String] = []
	for item: ItemData in game_state.player.inventory:
		item_names.append(item.name)
	return "Inventory: %s" % ", ".join(item_names)


func _get_map_response() -> String:
	var discovered_count: int = game_state.discovered_room_ids.size()
	var total_count: int = game_state.rooms.size()
	return "Map: %d of %d rooms discovered. Your current location is %s." % [discovered_count, total_count, game_state.get_current_room().name]


func _get_help_response() -> String:
	return "Commands: look, north/south/east/west, n/s/e/w, map, inventory, talk <npc name>, help."
