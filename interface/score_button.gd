extends Button
class_name ScoreButton

var score: int = 0


func set_score(total: int):
	score = total
	if total >= 1000:
		add_theme_font_size_override("font_size", 8)
	text = "$%0.2f" % (float(total) / 100)
