extends Control


func _on_field_button_pressed() -> void:
	pass # Replace with function body.


func _on_lab_button_pressed() -> void:
	if not %LabFloater.is_visible():
		%LabFloater.fade_in(%LabButton.global_position)
	else:
		%LabFloater.fade_out(%LabButton.global_position)


func _on_farm_button_pressed() -> void:
	pass # Replace with function body.


func _on_evo_button_pressed() -> void:
	pass # Replace with function body.
