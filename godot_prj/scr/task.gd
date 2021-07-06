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

func serialize():
	var json = "\t\t{"
	json += "\"name\":\"" + m_task_name + "\","
	json += "\"start_time\":\"" + str(m_start_time) + "\","
	json += "\"round_time\":\"" + str(m_round_time) + "\","
	json += "\"break_time\":\"" + str(m_break_time) + "\","
	json += "\"rounds_count\":\"" + str(m_rounds_count) + "\","
	json += "\"status\":\"" + str(m_status) + "\""
	json += "}"

func deserialize(task_data):
	pass
