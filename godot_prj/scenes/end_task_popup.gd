extends TextureButton

signal close

func _ready():
	connect("pressed", self, "close_popup")
	$ok_btn.connect("pressed", self, "close_popup")
	setup(3, 25, 5)

func setup(rounds_count, round_time, break_time):
	$work_time.text = "Working time: " + str(rounds_count) + " rounds x " + str(round_time) + " minutes"
	$break_time.text = "Break time: " + str(rounds_count - 1) + " rounds x " + str(break_time) + " minutes"
	$total_time.text = "Total time: " + str(rounds_count * round_time + (rounds_count - 1) * break_time) + " minutes"

func close_popup():
	emit_signal("close")
