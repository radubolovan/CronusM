extends Control

const c_min_task_working_time = 5
const c_max_task_working_time = 120
const c_start_task_working_time = 25
const c_mofidy_task_working_time = 5

const c_min_task_break_time = 5
const c_max_task_break_time = 10
const c_start_task_break_time = c_min_task_break_time
const c_modify_task_break_time = 1

const c_tasks_save_filepath = "uesr://tasks.txt"

var m_task_working_time = 0
var m_task_break_time = 0

var m_task_working_started = false
var m_task_working_timer = 0.0

var m_task_break_started = false
var m_task_break_timer = 0.0

var m_working_round_count = 0

var m_task_is_paused = false

enum TimeFormat {
	FORMAT_HOURS   = 1 << 0,
	FORMAT_MINUTES = 1 << 1,
	FORMAT_SECONDS = 1 << 2,
	FORMAT_DEFAULT = 1 << 0 | 1 << 1 | 1 << 2
	#FORMAT_DEFAULT = TimeFormat.FORMAT_HOURS | TimeFormat.FORMAT_MINUTES | TimeFormat.FORMAT_SECONDS
}

enum e_sfx_type{
	start_working = 0,
	pause_working = 1,
	unpause_working = 2,
	start_break = 3,
	task_done = 4
}

const c_start_working_snd = [
	"res://snd/start_working_001.ogg",
	"res://snd/start_working_002.ogg"
]

const c_pause_work_snd = [
	"res://snd/task_pause_001.ogg",
	"res://snd/task_pause_002.ogg"
]

const c_unpause_work_snd = [
	"res://snd/task_unpause_001.ogg",
	"res://snd/task_unpause_002.ogg",
	"res://snd/task_unpause_003.ogg"
]

const c_start_break_snd = [
	"res://snd/start_break_001.ogg",
	"res://snd/start_break_002.ogg"
]

const c_task_done_snd = [
	"res://snd/task_done_001.ogg",
	"res://snd/task_done_002.ogg"
]

const c_task_snd = [
	c_start_working_snd,
	c_pause_work_snd,
	c_unpause_work_snd,
	c_start_break_snd,
	c_task_done_snd
]

func _ready():
	randomize()

	m_task_working_time = c_start_task_working_time
	update_task_working_time()

	m_task_break_time = c_start_task_break_time
	update_task_break_time()

	$wd.connect("pressed", self, "on_decrease_task_working_time")
	$wi.connect("pressed", self, "on_increase_task_working_time")

	$bd.connect("pressed", self, "on_decrease_task_break_time")
	$bi.connect("pressed", self, "on_increase_task_break_time")
	
	$start_task_btn.connect("pressed", self, "on_task_start_working")
	$pause_task_btn.connect("pressed", self, "on_pause_task")
	$end_task_btn.connect("pressed", self, "on_end_task")

	$end_task_popup.visible = false
	$end_task_popup.connect("close", self, "on_close_end_task_popup")

	initialize()

func read_savefile():
	var f = File.new()
	var err = f.open(c_tasks_save_filepath, File.READ)
	if(err != OK):
		return

func initialize():
	$round.text = "Task not started"
	$timer.text = "00:00"
	$task_name.text = "Work"

	$start_task_btn.disabled = false
	$pause_task_btn.disabled = true
	$pause_task_btn.text = "Pause task"
	$end_task_btn.disabled = true

	$break_text.visible = false

	$pause_text.visible = false

	m_task_working_started = false
	m_task_working_timer = 0.0

	m_task_break_started = false
	m_task_break_timer = 0.0

	m_working_round_count = 0

	m_task_is_paused = false

	enable_buttons(true)

func _process(delta):
	if(m_task_is_paused):
		return
	
	if(m_task_working_started):
		m_task_working_timer += delta
		var time_left = m_task_working_time * 60.0 - m_task_working_timer
		$timer.text = format_time(time_left, TimeFormat.FORMAT_MINUTES | TimeFormat.FORMAT_SECONDS)
		if(m_task_working_timer >= m_task_working_time * 60.0):
			on_task_start_break()

	if(m_task_break_started):
		m_task_break_timer += delta
		var time_left = m_task_break_time * 60.0 - m_task_break_timer
		$timer.text = format_time(time_left, TimeFormat.FORMAT_MINUTES | TimeFormat.FORMAT_SECONDS)
		if(m_task_break_timer >= m_task_break_time * 60.0):
			continue_task()

func update_task_working_time():
	$task_working_time.text = str(m_task_working_time)

func update_task_break_time():
	$task_break_time.text = str(m_task_break_time)

func on_decrease_task_working_time():
	m_task_working_time -= c_mofidy_task_working_time
	if(m_task_working_time <= c_min_task_working_time):
		m_task_working_time = c_min_task_working_time
		$wd.disabled = true
	else:
		$wd.disabled = false
	$wi.disabled = false
	update_task_working_time()

func on_increase_task_working_time():
	m_task_working_time += c_mofidy_task_working_time
	if(m_task_working_time >= c_max_task_working_time):
		m_task_working_time = c_max_task_working_time
		$wi.disabled = true
	else:
		$wi.disabled = false
	$wd.disabled = false
		
	update_task_working_time()

func on_decrease_task_break_time():
	m_task_break_time -= c_modify_task_break_time
	if(m_task_break_time <= c_min_task_break_time):
		m_task_break_time = c_min_task_break_time
		$bd.disabled = true
	else:
		$bd.disabled = false
	$bi.disabled = false
	update_task_break_time()

func on_increase_task_break_time():
	m_task_break_time += c_modify_task_break_time
	if(m_task_break_time >= c_max_task_break_time):
		m_task_break_time = c_max_task_break_time
		$bi.disabled = true
	else:
		$bi.disabled = false
	$bd.disabled = false
	update_task_break_time()

func enable_buttons(enable : bool):
	$task_name.editable = enable
	$wd.disabled = !enable
	$wi.disabled = !enable
	$bd.disabled = !enable
	$bi.disabled = !enable
	$start_task_btn.disabled = !enable
	$pause_task_btn.disabled = enable
	$end_task_btn.disabled = enable

func on_task_start_working():
	m_working_round_count = 1
	m_task_working_timer = 0.0
	m_task_working_started = true
	m_task_break_started = false
	enable_buttons(false)
	$pause_task_btn.disabled = false
	$round.text = "Round: " + str(m_working_round_count)
	$break_text.visible = false
	play_sound(e_sfx_type.start_working)

func continue_task():
	m_working_round_count += 1
	m_task_working_timer = 0.0
	m_task_working_started = true
	m_task_break_started = false
	enable_buttons(false)
	$pause_task_btn.disabled = false
	$round.text = "Round: " + str(m_working_round_count)
	$break_text.visible = false
	play_sound(e_sfx_type.start_working)

func on_task_start_break():
	m_task_break_timer = 0.0
	m_task_working_started = false
	m_task_break_started = true
	$pause_task_btn.disabled = true
	$break_text.visible = true
	play_sound(e_sfx_type.start_break)

func on_pause_task():
	m_task_is_paused = !m_task_is_paused
	if(!m_task_is_paused):
		$pause_task_btn.text = "Pause task"
		play_sound(e_sfx_type.unpause_working)
	else:
		$pause_task_btn.text = "Unpause task"
		play_sound(e_sfx_type.pause_working)
	$pause_text.visible = m_task_is_paused

func on_end_task():
	play_sound(e_sfx_type.task_done)
	$end_task_popup.setup(m_working_round_count, m_task_working_time, m_task_break_time)
	$end_task_popup.visible = true

func play_sound(sfx_type):
	$sound.stream = get_sound(sfx_type)
	$sound.play()

func get_sound(sfx_type):
	var snds = c_task_snd[sfx_type]
	var snd = snds[randi() % snds.size()]
	return load(snd)

func on_close_end_task_popup():
	$end_task_popup.visible = false
	initialize()

func write_task_to_file():
	pass

"""
Credits for this function goes to: https://godotengine.org/qa/32785/is-there-simple-way-to-convert-seconds-to-hh-mm-ss-format-godot
OBS: my version is modified in order to fix a few bugs
"""
func format_time(time, format = TimeFormat.FORMAT_DEFAULT, digit_format = "%02d"):
	var digits = []

	if format & TimeFormat.FORMAT_HOURS:
		var hours = digit_format % [int(ceil(time)) / 3600]
		digits.append(hours)

	if format & TimeFormat.FORMAT_MINUTES:
		var minutes = digit_format % [int(ceil(time)) / 60]
		digits.append(minutes)

	if format & TimeFormat.FORMAT_SECONDS:
		var seconds = digit_format % [int(ceil(time)) % 60]
		digits.append(seconds)

	var formatted = String()
	var colon = ":"

	for digit in digits:
		formatted += digit + colon

	if not formatted.empty():
		formatted = formatted.rstrip(colon)

	return formatted
