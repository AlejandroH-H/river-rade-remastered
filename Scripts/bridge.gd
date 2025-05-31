extends Area2D

@onready var tilemap = get_tree().get_root().find_child("TileMapLayer", true, false)  # Por esta monda no me está sirviendo
@export var bridge_tile_ids: Array[int] = [3, 4, 5]  # IDs de tiles del puente
@export var water_tile_id = 2 # ID del tile de agua

var destroyed := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_body_entered(body):
	if destroyed:
		return
	if body.name == "Raider":
		print("🚨 El jugador chocó con el puente, ¡muere!")  
		body.die()  # Método de muerte del jugador
		queue_free()

func _on_area_entered(area):
	print("⚡ Área impactada por:", area.name)
	if destroyed:
		return
	if area.is_in_group("projectiles") or area.get_parent().is_in_group("projectiles"):
		print("💥 ¡Bala impactó el puente!")  
		destroyed = true
		area.queue_free()
		replace_bridge_with_water()
		#$Explosion.play()
		#$Explosion.connect("finished", _on_audio_finished)
		
		
#func _on_audio_finished():
	#replace_bridge_with_water()

func replace_bridge_with_water(): 
	$Explosion.play()
	var used_rect = tilemap.get_used_rect() # Obtener límites del TileMap 
	for x in range(used_rect.position.x, used_rect.end.x): 
		for y in range(used_rect.position.y, used_rect.end.y): 
			var cell = Vector2i(x, y) # Confirmar si la celda está dentro del rango de uso del mapa 
			if (cell.x >= used_rect.position.x) and (cell.y >= used_rect.position.y): 
				var tile_id = tilemap.get_cell_source_id(cell) 
				if tile_id in bridge_tile_ids: 
					tilemap.set_cell(cell, water_tile_id) # Matenme
					#print("✅ Celda reemplazada por agua en:", cell) 
				else:
					print("⚠️ Celda fuera de los límites, no se modifica:", cell) 
	tilemap.queue_redraw()
	queue_free()
