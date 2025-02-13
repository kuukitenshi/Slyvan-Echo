extends CanvasLayer

func level(type):
	$CurrentLevel.text = type
	
func gems(num):
	$GemsLabel.text = "Gems: " + str(num)
