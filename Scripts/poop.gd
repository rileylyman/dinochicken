extends AnimatedSprite2D

var keepTime: float = 3.0

var targetPOS: Vector2 = Vector2.ZERO

func _ready() -> void:
	if targetPOS == Vector2.ZERO:
		var viewportSize = get_viewport_rect().size
		targetPOS = Vector2(viewportSize.x - 50, 50)
	
	animation_finished.connect(_on_animation_finished)
	play("pooping")

func _on_animation_finished() -> void:
	var total_frames = get_sprite_frames().get_frame_count(animation)
	frame = total_frames - 1
	await get_tree().create_timer(keepTime).timeout
	Fly_To_Corner()

func Fly_To_Corner() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "global_position", targetPOS, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(0.2, 0.2), 1.0)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.chain().tween_callback(queue_free)
