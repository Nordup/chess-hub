extends Control

const SHOWN = Color(1, 1, 1, 1)
const HIDDEN = Color(1, 1, 1, 0)

@export var wait_connection: float = 15
@export var fade_in: float = 1.5
@export var fade_out: float = 0.3
@export var connection_events: ConnectionEvents
@export var root: Control

var was_connected: bool
var was_shown: bool
var tween: Tween


func _ready() -> void:
	connection_events.status_changed.connect(status_changed)
	show_message_after_delay()


func status_changed(status : ConnectionEvents.Status) -> void:
	if status == ConnectionEvents.Status.CONNECTED:
		was_connected = true
		hide_message()
	elif status == ConnectionEvents.Status.FAILED_TO_CONNECT and not was_shown:
		show_message()


func show_message_after_delay() -> void:
	visible = true
	root.hide()
	root.modulate = HIDDEN
	root.mouse_filter = Control.MOUSE_FILTER_PASS
	
	await get_tree().create_timer(wait_connection).timeout
	if was_connected: return
	
	show_message()


func _input(event: InputEvent) -> void:
	if not root.visible: return
	if not event.is_action_pressed("skip"): return
	
	hide_message()


func show_message() -> void:
	if root.visible: return
	
	root.show()
	was_shown = true
	
	if is_instance_valid(tween): tween.stop()
	tween = get_tree().create_tween()
	tween.tween_property(root, "modulate", SHOWN, fade_in)
	await tween.finished
	
	EditMode.set_enabled(true)
	EditMode.set_connection_msg(true)
	root.mouse_filter = Control.MOUSE_FILTER_STOP


func hide_message() -> void:
	if not root.visible: return
	
	EditMode.set_enabled(false)
	EditMode.set_connection_msg(false)
	root.mouse_filter = Control.MOUSE_FILTER_PASS
	
	if is_instance_valid(tween): tween.stop()
	tween = get_tree().create_tween()
	tween.tween_property(root, "modulate", HIDDEN, fade_out)
	await tween.finished
	
	root.hide()
