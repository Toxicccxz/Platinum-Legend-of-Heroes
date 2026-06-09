class_name InventoryPanel
extends PanelContainer

@onready var inventory_label: Label = $MarginContainer/VBoxContainer/InventoryLabel
@onready var equipped_label: Label = $MarginContainer/VBoxContainer/EquippedLabel
@onready var quest_label: Label = $MarginContainer/VBoxContainer/QuestLabel


func refresh(game_state: GameState) -> void:
	var inventory_names: Array[String] = []
	for item: ItemData in game_state.player.inventory:
		inventory_names.append(item.name)

	var equipped_names: Array[String] = []
	for item: ItemData in game_state.player.equipped_items:
		equipped_names.append(item.name)

	inventory_label.text = "Inventory:\n%s" % ("\n".join(inventory_names) if not inventory_names.is_empty() else "Empty")
	equipped_label.text = "Equipped:\n%s" % ("\n".join(equipped_names) if not equipped_names.is_empty() else "None")
	quest_label.text = "Notes:\nExplore the village and investigate the old shrine."
