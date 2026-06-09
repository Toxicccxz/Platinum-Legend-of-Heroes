class_name MapPanel
extends Control

const CELL_SIZE: float = 54.0
const CELL_GAP: float = 26.0
const ROOM_SIZE: Vector2 = Vector2(CELL_SIZE, CELL_SIZE)
var game_state: GameState


func refresh(state: GameState) -> void:
	game_state = state
	queue_redraw()


func _draw() -> void:
	if game_state == null:
		return

	draw_rect(Rect2(Vector2.ZERO, size), Color(0.055, 0.065, 0.075), true)

	var room_positions: Dictionary = _get_room_screen_positions()
	_draw_paths(room_positions)
	_draw_rooms(room_positions)


func _get_room_screen_positions() -> Dictionary:
	var min_position: Vector2i = Vector2i(9999, 9999)
	var max_position: Vector2i = Vector2i(-9999, -9999)

	for room: RoomData in game_state.rooms.values():
		min_position.x = mini(min_position.x, room.grid_position.x)
		min_position.y = mini(min_position.y, room.grid_position.y)
		max_position.x = maxi(max_position.x, room.grid_position.x)
		max_position.y = maxi(max_position.y, room.grid_position.y)

	var grid_columns: int = max_position.x - min_position.x + 1
	var grid_rows: int = max_position.y - min_position.y + 1
	var grid_size: Vector2 = Vector2(grid_columns, grid_rows) * (CELL_SIZE + CELL_GAP) - Vector2(CELL_GAP, CELL_GAP)
	var origin: Vector2 = (size - grid_size) * 0.5
	var positions: Dictionary = {}

	for room: RoomData in game_state.rooms.values():
		var offset: Vector2i = room.grid_position - min_position
		positions[room.id] = origin + Vector2(offset.x, offset.y) * (CELL_SIZE + CELL_GAP)

	return positions


func _draw_paths(room_positions: Dictionary) -> void:
	var drawn_paths: Dictionary = {}

	for room: RoomData in game_state.rooms.values():
		for direction: String in room.exits.keys():
			var target_id: String = room.exits[direction] as String
			var path_key: String = _get_path_key(room.id, target_id)
			if drawn_paths.has(path_key) or not room_positions.has(target_id):
				continue

			var from_center: Vector2 = room_positions[room.id] + ROOM_SIZE * 0.5
			var to_center: Vector2 = room_positions[target_id] + ROOM_SIZE * 0.5
			var visible: bool = game_state.is_room_discovered(room.id) or game_state.is_room_discovered(target_id)
			var path_color: Color = Color(0.55, 0.62, 0.68) if visible else Color(0.18, 0.2, 0.22)
			draw_line(from_center, to_center, path_color, 4.0, true)
			drawn_paths[path_key] = true


func _draw_rooms(room_positions: Dictionary) -> void:
	for room: RoomData in game_state.rooms.values():
		var room_rect: Rect2 = Rect2(room_positions[room.id], ROOM_SIZE)
		var discovered: bool = game_state.is_room_discovered(room.id)
		var current: bool = room.id == game_state.player.current_room_id
		var fill_color: Color = Color(0.18, 0.24, 0.28) if discovered else Color(0.08, 0.09, 0.1)
		var border_color: Color = Color(0.65, 0.72, 0.78) if discovered else Color(0.2, 0.22, 0.24)

		if current:
			fill_color = Color(0.95, 0.78, 0.28)
			border_color = Color(1.0, 0.95, 0.66)

		draw_rect(room_rect, fill_color, true)
		draw_rect(room_rect, border_color, false, 3.0)

		if discovered:
			var label: String = _get_room_abbreviation(room.name)
			var font: Font = get_theme_default_font()
			var font_size: int = 14
			var text_size: Vector2 = font.get_string_size(label, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
			var text_position: Vector2 = room_rect.position + (ROOM_SIZE - text_size) * 0.5 + Vector2(0, font_size * 0.75)
			var text_color: Color = Color(0.05, 0.05, 0.05) if current else Color(0.9, 0.92, 0.9)
			draw_string(font, text_position, label, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, text_color)


func _get_room_abbreviation(room_name: String) -> String:
	var words: PackedStringArray = room_name.split(" ", false)
	if words.size() == 1:
		return words[0].substr(0, 3).to_upper()

	var abbreviation: String = ""
	for word: String in words:
		abbreviation += word.substr(0, 1).to_upper()
	return abbreviation


func _get_path_key(from_id: String, to_id: String) -> String:
	var ids: Array[String] = [from_id, to_id]
	ids.sort()
	return "%s:%s" % [ids[0], ids[1]]
