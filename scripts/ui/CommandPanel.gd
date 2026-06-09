class_name CommandPanel
extends PanelContainer

signal command_submitted(command: String)

@onready var message_log: RichTextLabel = $MarginContainer/VBoxContainer/MessageLog
@onready var command_input: LineEdit = $MarginContainer/VBoxContainer/CommandInput


func _ready() -> void:
	message_log.scroll_following = true
	command_input.text_submitted.connect(_on_text_submitted)
	command_input.grab_focus()


func append_player_command(command: String) -> void:
	_append_line("> %s" % command)


func append_system_message(message: String) -> void:
	_append_line(message)


func _append_line(message: String) -> void:
	message_log.append_text("%s\n" % message)


func _on_text_submitted(command: String) -> void:
	var clean_command: String = command.strip_edges()
	command_input.clear()
	command_submitted.emit(clean_command)
