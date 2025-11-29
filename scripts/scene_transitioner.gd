extends CanvasLayer


var time = 0.5

func transition(f : Callable):
	var t = create_tween()
	t.tween_property($ColorRect, "color:a", 1, time)
	t.play()
	
	await t.finished
	f.call()
	
	create_tween().tween_property($ColorRect, "color:a", 0, time)
	
