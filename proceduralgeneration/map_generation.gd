extends Level


func _ready()->void:
	wallH=Vector2i(3,1)#Horizaontal Wall
	wallV=Vector2i(2,0)#Vertical Wall
	topLeft=Vector2i(1,2)#Top Left Corner
	topRight=Vector2i(2,2)#Top Right Corner
	bottomLeft=Vector2i(1,3)#Bottom Left Corner
	bottomRight=Vector2i(2,3)#Top Right Corner
	wallCross = Vector2i(1, 1)#Top Left Corner
	leftJoin=Vector2i(0,1)#Teewee from tetris
	rightJoin=Vector2i(1,1)#Teewee from tetris
	topJoin=Vector2i(1,0)#Teewee from tetris
	bottomJoin=Vector2i(0,0)#Teewee from tetris
	connectTilesID=2
	wallTilesID=1
	generate_grid_map()
	generate_map()


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
