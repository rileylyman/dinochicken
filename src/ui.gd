class_name RootUi
extends Control

var _floaters: Array[Floater] = []

func _ready() -> void:
	for c in get_children():
		if c is Floater:
			_floaters.append(c)

func send_floater_to_front(floater: Floater) -> void:
	move_child(floater, -1)

func _on_field_button_pressed() -> void:
	if not %FieldFloater.is_visible():
		%FieldFloater.fade_in(%FieldButton.global_position)
	else:
		%FieldFloater.fade_out(%FieldButton.global_position)


func _on_lab_button_pressed() -> void:
	if not %LabFloater.is_visible():
		%LabFloater.fade_in(%LabButton.global_position)
	else:
		%LabFloater.fade_out(%LabButton.global_position)


func _on_farm_button_pressed() -> void:
	if not %FarmFloater.is_visible():
		%FarmFloater.fade_in(%FarmButton.global_position)
	else:
		%FarmFloater.fade_out(%FarmButton.global_position)


func _on_evo_button_pressed() -> void:
	pass # Replace with function body.
