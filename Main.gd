extends Control

var drag_position = null
var minutes_to_call_notification := 1
var current_minute : int
var start_at_current_time := false
var minutes_past_starting_minute : int

var currentSpace : Control
@onready var allSpaces := $VBoxContainer/HBoxContainer/MarginContainer.get_children()
@onready var timeToCallNotificationSpinBox = $VBoxContainer/HBoxContainer/MarginContainer/DefaultSpace/TimeToCallNotificationContainer/TimeToCallNotification
signal call_time_checker_notification

func _ready():
	$Configuration.onApplicationStart()
	currentSpace = allSpaces[0]
	minutes_to_call_notification = timeToCallNotificationSpinBox.value

func _on_current_time_minute_changed(minute):
	current_minute = minute
	if not start_at_current_time:
		if current_minute % minutes_to_call_notification == 0:
			emit_signal("call_time_checker_notification")
	else:
		minutes_past_starting_minute += 1
		if minutes_past_starting_minute == 61:
			minutes_past_starting_minute = 1
		if minutes_past_starting_minute % minutes_to_call_notification == 0:
			emit_signal(("call_time_checker_notification"))

func _on_time_to_call_notification_value_changed(value):
	print("time to call notification value changed " + str(value))
	minutes_to_call_notification = value
	#also reset minutes past time notification.
	minutes_past_starting_minute = 0


func _on_check_button_toggled(toggled_on):
	print("button toggled, value: " + str(toggled_on))
	start_at_current_time = toggled_on
	if toggled_on:
		minutes_past_starting_minute = 0

func _on_space_button_pressed(which):
	if(which == "Time" and currentSpace != allSpaces[0]):
		switchSpaces(allSpaces[0])
	elif(which == "Storage" and currentSpace != allSpaces[1]):
		switchSpaces(allSpaces[1])
	else:
		print_debug("Button not recognized")

func switchSpaces(spaceToSwitchTo):
	currentSpace.hide()
	currentSpace = spaceToSwitchTo
	currentSpace.show()

func _on_title_panel_gui_input(event):
	if event is InputEventMouseButton:
		var initial_mouse_position = Vector2i(get_global_mouse_position())
		if event.pressed:
			#start draggin
			drag_position = Vector2i(get_global_mouse_position())
		else:
			#end draggin
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		DisplayServer.window_set_position(DisplayServer.window_get_position() + Vector2i(event.global_position) - drag_position) 

