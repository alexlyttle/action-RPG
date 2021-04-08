# Adds feature to disable short cuts
extends ShortCut
class_name ShortCutMod

var disabled = false setget set_disabled
var _disabled_shortcut = null

func set_disabled(value):
	if value != disabled:
		disabled = value
		if disabled:
			_disabled_shortcut = shortcut
			shortcut = null
		else:
			shortcut = _disabled_shortcut
			_disabled_shortcut = null


func enable():
	self.disabled = false

func disable():
	self.disabled = true
