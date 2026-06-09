class_name PlayerState
extends RefCounted

var name: String = "Wanderer"
var level: int = 1
var hp: int = 30
var max_hp: int = 30
var energy: int = 12
var max_energy: int = 12
var strength: int = 8
var agility: int = 7
var intelligence: int = 9
var constitution: int = 8
var gold: int = 15
var current_room_id: String = "village_square"
var inventory: Array[ItemData] = []
var equipped_items: Array[ItemData] = []
