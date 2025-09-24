extends MeshInstance3D
class_name InteractableAnimation

const SIN_EFFECT = &"SinEffect"
const ALBEDO = &"Albedo"
const GAP = &"Gap"

@export var active_sin_effect: float
@export var active_color: Color
@export var active_gap: float
@export var tween_time: float
@export var tween_trans: Tween.TransitionType

var tween: Tween

var default_sin_effect: float = 0.2
var default_color: Color = Color(0.733, 0.0, 1.0, 0.533)
var default_gap: float = 0.0

var current_sin_effect: float
var current_color: Color
var current_gap: float


func _ready() -> void:
	if Connection.is_server(): return
	current_sin_effect = default_sin_effect
	current_color = default_color
	current_gap = default_gap


func play_activate() -> void:
	if is_instance_valid(tween): tween.stop()
	tween = get_tree().create_tween().set_parallel().set_trans(tween_trans)
	tween.tween_method(set_sin_effect_param, current_sin_effect, active_sin_effect, tween_time)
	tween.tween_method(set_albedo_param, current_color, active_color, tween_time)
	tween.tween_method(set_gap_param, current_gap, active_gap, tween_time)


func play_deactivate() -> void:
	if is_instance_valid(tween): tween.stop()
	tween = get_tree().create_tween().set_parallel().set_trans(tween_trans)
	tween.tween_method(set_sin_effect_param, current_sin_effect, default_sin_effect, tween_time)
	tween.tween_method(set_albedo_param, current_color, default_color, tween_time)
	tween.tween_method(set_gap_param, current_gap, default_gap, tween_time)


func set_sin_effect_param(value: float) -> void:
	current_sin_effect = value
	set_instance_shader_parameter(SIN_EFFECT, value)


func set_albedo_param(value: Color) -> void:
	current_color = value
	set_instance_shader_parameter(ALBEDO, value)


func set_gap_param(value: float) -> void:
	current_gap = value
	set_instance_shader_parameter(GAP, value)
