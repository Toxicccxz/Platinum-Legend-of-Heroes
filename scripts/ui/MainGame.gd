extends Control

@onready var character_panel: CharacterPanel = $Root/MainSplit/CharacterPanel
@onready var map_panel: MapPanel = $Root/MainSplit/CenterColumn/MapPanel
@onready var location_panel: LocationPanel = $Root/MainSplit/CenterColumn/LocationPanel
@onready var command_panel: CommandPanel = $Root/MainSplit/CenterColumn/CommandPanel
@onready var inventory_panel: InventoryPanel = $Root/MainSplit/InventoryPanel

var game_state: GameState
var command_parser: CommandParser


func _ready() -> void:
	game_state = GameState.new()
	command_parser = CommandParser.new(game_state)
	command_panel.command_submitted.connect(_on_command_submitted)
	_refresh_ui()
	command_panel.append_system_message("Welcome to Platinum Legend of Heroes.")
	command_panel.append_system_message(game_state.describe_current_room())
	command_panel.append_system_message("Type 'help' to see available commands.")


func _on_command_submitted(command: String) -> void:
	if command.is_empty():
		return

	command_panel.append_player_command(command)
	var responses: Array[String] = command_parser.parse(command)
	for response: String in responses:
		command_panel.append_system_message(response)
	_refresh_ui()


func _refresh_ui() -> void:
	character_panel.refresh(game_state)
	map_panel.refresh(game_state)
	location_panel.refresh(game_state)
	inventory_panel.refresh(game_state)
