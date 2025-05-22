extends Line2D

signal time_to_die

func _decrease():
	points[1].y += 10

func _is_time_to_die():
	return points[1].y >= 0
	#Todo hasta acá. es sobre el funcionamiento de la barra del timer
	

func _on_fuel_timeout() -> void:
	_decrease()
	
	if _is_time_to_die():
		$Fuel.stop()
		emit_signal("time_to_die")
		#Se detiene el timer y se emite la señal
