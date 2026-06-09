class_name CharacterPanel
extends PanelContainer

@onready var player_name_label: Label = $MarginContainer/VBoxContainer/PlayerNameLabel
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var hp_label: Label = $MarginContainer/VBoxContainer/HPLabel
@onready var energy_label: Label = $MarginContainer/VBoxContainer/EnergyLabel
@onready var strength_label: Label = $MarginContainer/VBoxContainer/StrengthLabel
@onready var agility_label: Label = $MarginContainer/VBoxContainer/AgilityLabel
@onready var intelligence_label: Label = $MarginContainer/VBoxContainer/IntelligenceLabel
@onready var constitution_label: Label = $MarginContainer/VBoxContainer/ConstitutionLabel
@onready var gold_label: Label = $MarginContainer/VBoxContainer/GoldLabel
@onready var location_label: Label = $MarginContainer/VBoxContainer/LocationLabel


func refresh(game_state: GameState) -> void:
	var player: PlayerState = game_state.player
	var room: RoomData = game_state.get_current_room()

	player_name_label.text = "Name: %s" % player.name
	level_label.text = "Level: %d" % player.level
	hp_label.text = "HP: %d / %d" % [player.hp, player.max_hp]
	energy_label.text = "Energy: %d / %d" % [player.energy, player.max_energy]
	strength_label.text = "Strength: %d" % player.strength
	agility_label.text = "Agility: %d" % player.agility
	intelligence_label.text = "Intelligence: %d" % player.intelligence
	constitution_label.text = "Constitution: %d" % player.constitution
	gold_label.text = "Gold: %d" % player.gold
	location_label.text = ("Location: %s" % room.name) if room != null else "Location: Unknown"
