class_name Floater
extends ColorRect

const padding_x := 128
const padding_y := 64

const tween_time := 0.2

@export var fade_out_target: Control = null

var _dragging := false
@onready var _last_known_pos: Vector2 = get_viewport().size / 2


func fade_out(pos: Vector2) -> void:
	_last_known_pos = global_position
	var tween = create_tween().set_parallel()
	tween.tween_property(self , "global_position", pos, tween_time)
	tween.tween_property(self , "scale", Vector2.ZERO, tween_time)
	await tween.finished
	visible = false

func fade_in(pos: Vector2) -> void:
	visible = true
	global_position = pos
	scale = Vector2.ZERO
	var tween = create_tween().set_parallel()
	tween.tween_property(self , "global_position", _last_known_pos, tween_time)
	tween.tween_property(self , "scale", Vector2.ONE, tween_time)

func _process(_delta: float) -> void:
	var r = get_global_rect()
	if r.position.x > get_viewport().size.x - padding_x:
		position.x = get_viewport().size.x - padding_x
	if r.position.y > get_viewport().size.y - padding_y:
		position.y = get_viewport().size.y - padding_y
	if r.end.x < padding_x:
		position.x = padding_x - r.size.x
	if r.position.y < 0:
		position.y = 0

func _on_top_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_dragging = event.pressed
	if event is InputEventMouseMotion and _dragging:
		position += event.relative


func _on_button_pressed() -> void:
	if fade_out_target:
		fade_out(fade_out_target.global_position)
	else:
		fade_out(Vector2.ZERO)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var hovered := get_viewport().gui_get_hovered_control()
		if hovered == self or self.is_ancestor_of(hovered):
			if get_tree().current_scene is RootUi:
				get_tree().current_scene.send_floater_to_front(self)

