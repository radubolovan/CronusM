extends Node

class_name CMTask

enum TaskStatus {
	e_task_status_WIP = 0,
	e_task_status_finished = 1
}

var m_task_name = "default_task_name"
var m_start_time = 0
var m_round_time = 0
var m_break_time = 0
var m_rounds_count = 0
var m_status = TaskStatus.e_task_status_WIP

func start(task_name, start_timestamp, round_time, break_time):
	m_task_name = task_name
	m_start_time = start_timestamp
	m_round_time = round_time
	m_break_time = break_time
	m_rounds_count = 1
	m_status = TaskStatus.e_task_status_WIP

func add_round():
	m_rounds_count += 1

func end_task():
	m_status = TaskStatus.e_task_status_finished

func serialize():
	var json = "\t\t{"
	json += "\"name\":\"" + m_task_name + "\","
	json += "\"start_time\":\"" + str(m_start_time) + "\","
	json += "\"round_time\":\"" + str(m_round_time) + "\","
	json += "\"break_time\":\"" + str(m_break_time) + "\","
	json += "\"rounds_count\":\"" + str(m_rounds_count) + "\","
	json += "\"status\":\"" + str(m_status) + "\""
	json += "}"
	return json

func deserialize(task_data):
	m_task_name = task_data["name"]
	m_start_time = task_data["start_time"].to_int()
	m_round_time = task_data["round_time"].to_int()
	m_break_time = task_data["break_time"].to_int()
	m_rounds_count = task_data["rounds_count"].to_int()
	m_status = task_data["status"].to_int()

	#var dict = OS.get_datetime_from_unix_time(m_start_time)
	#print(dict)

func get_task_name():
	match m_status:
		TaskStatus.e_task_status_WIP: return "WIP"
		TaskStatus.e_task_status_finished: return "Finished"
	return "Wnknown task status type"
