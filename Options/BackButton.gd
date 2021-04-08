extends Button

var ShortCutMod = load("res://UI/ShortCutMod.gd")


func _ready():
	shortcut = ShortCutMod.new()
	shortcut.shortcut = InputEventAction.new()
	shortcut.shortcut.action = "ui_back"
