class_name HelpDialog
extends Window

func _on_close_requested():
	print("close requested")
	hide()
	queue_free()

func _on_close_button_pressed():
	print("pressed")
	_on_close_requested()
