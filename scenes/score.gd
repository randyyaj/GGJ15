extends Label

var counter = 0

func _ready():
	set_text(str(counter))


func increment():
	counter+=1
	set_text(str(counter))
	
	
func decrement():
	counter-=1
	set_text(str(counter))
	
	
func reset():
	counter = 0
	set_text(str(counter))