extends Button
class_name ScoreButton


func set_score(total: int):
	text = "$%0.2f" % (float(total) / 100)
