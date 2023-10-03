extends Panel
class_name ScoreUI

@export var board: String
@export var secret: String

@onready var input_name: LineEdit = $Rows/HBoxContainer/Container/NameTextEdit
@onready var score_button: ScoreButton = $Rows/UpperButtons/ScoreButton
@onready var submit_button: Button = $Rows/HBoxContainer/Container/SubmitButton
@onready var request: HTTPRequest = $SubmissionRequest


func _on_game_score_changed(total: int):
	score_button.set_score(total)


func lock():
	score_button.disabled = true
	submit_button.disabled = true
	submit_button.text = "Submitting..."


func unlock():
	score_button.disabled = false
	submit_button.disabled = false
	submit_button.text = "Submit"


func _on_submit_button_pressed():
	var player = input_name.text
	lock()
	request.request(
		"https://arcade.steffo.eu/score/?board=%s&player=%s" % [board, player],
		[
			"Authorization: Bearer %s" % secret,
			"Content-Type: application/json",
			"User-Agent: eu.steffo.ld54"
		],
		HTTPClient.METHOD_PUT,
		JSON.stringify(float(score_button.score) / 100.0)
	)


signal score_submission_success
signal score_submission_error


func _on_submission_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code in [200, 201]:
		score_submission_success.emit()
		print("[ScoreUI] Score submission successful!")
	else:
		push_error("Score submission failed. Printing details to output.")
		score_submission_error.emit()
		print("[ScoreUI] Score submission failed.")
		print("[ScoreUI] Result: ", result)
		print("[ScoreUI] Code: ", response_code)
		print("[ScoreUI] Headers: ", headers)
		print("[ScoreUI] Body: ", body)
	unlock()


signal score_button_pressed

func _on_score_button_pressed():
	score_button_pressed.emit()

