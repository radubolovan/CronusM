extends Node

enum TimeFormat {
	FORMAT_HOURS   = 1 << 0,
	FORMAT_MINUTES = 1 << 1,
	FORMAT_SECONDS = 1 << 2,
	FORMAT_DEFAULT = 1 << 0 | 1 << 1 | 1 << 2
	#FORMAT_DEFAULT = TimeFormat.FORMAT_HOURS | TimeFormat.FORMAT_MINUTES | TimeFormat.FORMAT_SECONDS
}

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