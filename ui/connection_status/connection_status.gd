extends Control
class_name ConnectionStatus

const SHOW = "show"
const HIDE = "hide"

const status_body = {
	ConnectionEvents.Status.CONNECTING : {
		"text" : "Connecting...",
		"color" : Color.YELLOW
	},
	ConnectionEvents.Status.FAILED_TO_CONNECT : {
		"text" : "Failed to connect",
		"color" : Color.RED
	},
	ConnectionEvents.Status.CONNECTED : { "text" : "Connected", "color" : Color.GREEN },
	ConnectionEvents.Status.DISCONNECTED : { "text" : "Disconnected", "color" : Color.RED },
}

@export var connection_events: ConnectionEvents
@export var label: Label
@export var panel: PanelContainer
@export var animation: AnimationPlayer
@export var queue_delay: float = 1.5
@export var hide_delay: float = 10.0

var queue_timer: Timer
var hide_timer: Timer

var current_status: ConnectionEvents.Status
var next_status: ConnectionEvents.Status
var just_changed: bool


func _ready() -> void:
	connection_events.status_changed.connect(set_status)
	animation.play(HIDE, -1, 1, true)
	
	hide_timer = Timer.new()
	hide_timer.timeout.connect(hide_status)
	add_child(hide_timer)
	
	queue_timer = Timer.new()
	queue_timer.timeout.connect(set_queued)
	add_child(queue_timer)


func set_status(status : ConnectionEvents.Status) -> void:
	next_status = status
	
	if not just_changed:
		set_queued()
	elif queue_timer.is_stopped():
		queue_timer.start(queue_delay)


func set_queued() -> void:
	queue_timer.stop()
	just_changed = true
	
	var cached_status = next_status
	if animation.assigned_animation == SHOW:
		animation.play(HIDE)
		animation.queue(SHOW)
		await animation.animation_changed
	else:
		animation.play(SHOW)
	
	current_status = cached_status
	label.text = status_body[cached_status].text
	panel["theme_override_styles/panel"].border_color = status_body[cached_status].color
	
	hide_timer.start(hide_delay)


func hide_status() -> void:
	hide_timer.stop()
	just_changed = false
	
	animation.play(HIDE)
