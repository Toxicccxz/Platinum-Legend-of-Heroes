class_name GameState
extends RefCounted

var player: PlayerState = PlayerState.new()
var rooms: Dictionary = {}
var discovered_room_ids: Dictionary = {}


func _init() -> void:
	_build_sample_world()
	discover_room(player.current_room_id)


func get_current_room() -> RoomData:
	return rooms.get(player.current_room_id) as RoomData


func get_room(room_id: String) -> RoomData:
	return rooms.get(room_id) as RoomData


func discover_room(room_id: String) -> void:
	if rooms.has(room_id):
		discovered_room_ids[room_id] = true


func is_room_discovered(room_id: String) -> bool:
	return discovered_room_ids.has(room_id)


func move_player(direction: String) -> String:
	var current_room: RoomData = get_current_room()
	var clean_direction: String = direction.to_lower()
	if current_room == null or not current_room.exits.has(clean_direction):
		return "You cannot go %s from here." % clean_direction

	var next_room_id: String = current_room.exits[clean_direction] as String
	player.current_room_id = next_room_id
	discover_room(next_room_id)

	var next_room: RoomData = get_current_room()
	return "You travel %s to %s." % [clean_direction, next_room.name]


func describe_current_room() -> String:
	var room: RoomData = get_current_room()
	if room == null:
		return "You are nowhere. Something has gone wrong."

	var lines: Array[String] = [room.name, room.description]
	var npc_names: Array[String] = get_current_npc_names()
	var item_names: Array[String] = get_current_item_names()

	if npc_names.is_empty():
		lines.append("NPCs: none")
	else:
		lines.append("NPCs: %s" % ", ".join(npc_names))

	if item_names.is_empty():
		lines.append("Items: none")
	else:
		lines.append("Items: %s" % ", ".join(item_names))

	lines.append("Exits: %s" % get_current_exit_text())
	return "\n".join(lines)


func get_current_npc_names() -> Array[String]:
	var names: Array[String] = []
	var room: RoomData = get_current_room()
	if room == null:
		return names

	for npc: NPCData in room.npcs:
		names.append(npc.name)
	return names


func get_current_item_names() -> Array[String]:
	var names: Array[String] = []
	var room: RoomData = get_current_room()
	if room == null:
		return names

	for item: ItemData in room.items:
		names.append(item.name)
	return names


func get_current_exit_text() -> String:
	var room: RoomData = get_current_room()
	if room == null:
		return "none"

	var exits: Array[String] = room.get_exit_names()
	if exits.is_empty():
		return "none"
	return ", ".join(exits)


func find_npc_in_current_room(search_name: String) -> NPCData:
	var room: RoomData = get_current_room()
	if room == null:
		return null

	var clean_name: String = search_name.strip_edges().to_lower()
	for npc: NPCData in room.npcs:
		if npc.id.to_lower() == clean_name or npc.name.to_lower() == clean_name:
			return npc
	return null


func _build_sample_world() -> void:
	var village: RoomData = RoomData.new("village_square", "Village Square", "A worn stone plaza sits at the heart of the village. Footpaths lead toward warm lanterns, ringing metal, trees, and water.", Vector2i(1, 1))
	var tavern: RoomData = RoomData.new("tavern", "Tavern", "The tavern smells of stew, old wood, and stories waiting for a listener.", Vector2i(1, 0))
	var blacksmith: RoomData = RoomData.new("blacksmith", "Blacksmith", "A hot forge glows beside racks of practical ironwork. Sparks snap in the smoky air.", Vector2i(2, 1))
	var forest_entrance: RoomData = RoomData.new("forest_entrance", "Forest Entrance", "The road narrows where the first old trees lean over the path.", Vector2i(1, 2))
	var deep_forest: RoomData = RoomData.new("deep_forest", "Deep Forest", "The canopy thickens here. Every sound feels close, then far away.", Vector2i(1, 3))
	var old_shrine: RoomData = RoomData.new("old_shrine", "Old Shrine", "Moss-covered stones circle a cracked shrine. A faint blue light pulses under the altar.", Vector2i(2, 3))
	var riverbank: RoomData = RoomData.new("riverbank", "Riverbank", "Clear water slides past reeds and smooth stones. The village path continues west.", Vector2i(0, 1))
	var cave_entrance: RoomData = RoomData.new("cave_entrance", "Cave Entrance", "A dark opening cuts into the hillside. Cool air drifts from within.", Vector2i(0, 2))

	village.add_exit("north", "tavern")
	village.add_exit("east", "blacksmith")
	village.add_exit("south", "forest_entrance")
	village.add_exit("west", "riverbank")
	tavern.add_exit("south", "village_square")
	blacksmith.add_exit("west", "village_square")
	forest_entrance.add_exit("north", "village_square")
	forest_entrance.add_exit("south", "deep_forest")
	forest_entrance.add_exit("west", "cave_entrance")
	deep_forest.add_exit("north", "forest_entrance")
	deep_forest.add_exit("east", "old_shrine")
	old_shrine.add_exit("west", "deep_forest")
	riverbank.add_exit("east", "village_square")
	riverbank.add_exit("south", "cave_entrance")
	cave_entrance.add_exit("north", "riverbank")
	cave_entrance.add_exit("east", "forest_entrance")

	tavern.npcs.append(NPCData.new("innkeeper", "Innkeeper", "A broad-shouldered innkeeper polishing a cup.", "Keep your boots dry and your questions sharper. The shrine lights have been restless lately."))
	blacksmith.npcs.append(NPCData.new("blacksmith", "Blacksmith", "A soot-streaked smith with calm eyes.", "If you head into the cave, take something sturdier than courage."))
	old_shrine.npcs.append(NPCData.new("acolyte", "Acolyte", "A quiet acolyte kneels beside the shrine.", "The old stones remember names. Some of them are not friendly."))

	riverbank.items.append(ItemData.new("smooth_stone", "Smooth Stone", "A flat river stone that fits neatly in your palm."))
	cave_entrance.items.append(ItemData.new("rusty_dagger", "Rusty Dagger", "A worn dagger left near the cave mouth."))
	player.inventory.append(ItemData.new("travel_cloak", "Travel Cloak", "A plain cloak, patched but reliable."))

	for room: RoomData in [village, tavern, blacksmith, forest_entrance, deep_forest, old_shrine, riverbank, cave_entrance]:
		rooms[room.id] = room
