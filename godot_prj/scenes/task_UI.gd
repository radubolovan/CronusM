extends NinePatchRect

func initialize(task_data):
	$task_name_lbl.text = "Task name: " + task_data.m_task_name
	var dict = OS.get_datetime_from_unix_time(task_data.m_start_time)
	var hours = "%02d" % [dict["hour"]]
	var minutes = "%02d" % [dict["minute"]]
	var seconds = "%02d" % [dict["second"]]
	$task_start_lbl.text = "Started: " + str(dict["year"]) + ", " + g_globals.get_month_name(dict["month"]) + " " + g_globals.get_day_name(dict["day"]) + ", " + hours + ":" + minutes + ":" + seconds
	$rounds_count_lbl.text = "Rounds: " + str(task_data.m_rounds_count)
	$round_time_lbl.text = "Round time: " + str(task_data.m_round_time)
	$breaks_count_lbl.text = "Breaks: " + str(task_data.m_rounds_count - 1)
	$break_time_lbl.text = "Break time: " + str(task_data.m_break_time)
	$status_lbl.text = task_data.get_task_name()
