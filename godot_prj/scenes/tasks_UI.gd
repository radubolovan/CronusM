extends TextureButton

signal close

func _ready():
	connect("pressed", self, "on_close")
	$close_btn.connect("pressed", self, "on_close")

func initialize(tasks):
	for idx in range($list/content.get_child_count(), 0, -1):
		$list/content.remove_child($list/content.get_child(idx))

	for idx in range(0, tasks.size()):
		var task_ui = load("res://scenes/task_UI.tscn").instance()
		task_ui.initialize(tasks[idx])
		$list/content.add_child(task_ui)

func on_close():
	emit_signal("close")
