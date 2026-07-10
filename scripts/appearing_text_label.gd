extends RichTextLabel

@onready var tween: Tween = create_tween().set_parallel(true)

func _ready():
	tween.tween_property(self, "position:y", position.y - 80, 1.4)
	tween.tween_property(self, "position:x", position.x + randf_range(-15, 15), 1.4)
	tween.tween_property(self, "modulate:a", 0.0, 1.4)
	tween.chain().tween_callback(queue_free)
