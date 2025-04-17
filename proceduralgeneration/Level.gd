extends Node2D
class_name Level

@onready var wallTilesLayer:TileMapLayer=$Wall

var pos_x
var pos_y

var enemy_types=[]
var enemy_pos=[]
var sample_pos=[]

var connectTilesID:int
var wallTilesID:int
var levelEndID:int
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

@onready var enemy1
@onready var enemy2
@onready var enemy3
#get the tiles
var wallH:Vector2i
var wallV:Vector2i
var topLeft:Vector2i
var topRight:Vector2i
var bottomLeft:Vector2i
var bottomRight:Vector2i
var wallCross:Vector2i # For wall intersections

var levelEndV:Vector2i
var levelEndH:Vector2i

var GRID_HEIGHT:int=rng.randi_range(3,5)
var GRID_WIDTH:int=rng.randi_range(3,4)

var ROOM_HEIGHT:int=12
var ROOM_WIDTH:int=19

var leftJoin:Vector2i
var rightJoin:Vector2i
var topJoin:Vector2i
var bottomJoin:Vector2i=Vector2i(2,0)
var arr:Array=[]

func generate_wall(x, y, value1, value2, value3, value4):
	arr[x][y] = [value1, value2, value3, value4]  # Set instead of append
	
#First I generate the matrix for the rooms
func generate_grid_map()->void:
	#0 means door
	#1 means wall
	rng.randomize()
	arr.clear()
	for x in range(GRID_WIDTH):
		arr.append([])
		for y in range(GRID_HEIGHT):
			arr[x].append([0,0,0,0])
	#CORNERS
	generate_wall(0,0,1,1,0,0)#TOP LEFT
	generate_wall(0,GRID_HEIGHT-1,1,0,0,1)#TOP RIGHT
	generate_wall(GRID_WIDTH-1,0,0,1,1,0)#BOTTOM LEFT
	generate_wall(GRID_WIDTH-1,GRID_HEIGHT-1,0,0,1,1)#BOTTOM RIGHT
	
	#RIGHT WALLS
	for x in range(1, GRID_WIDTH - 1):
		generate_wall(x, 0, 0, 1, 0, 0)  # (West wall)

	# BOTTOM WALL (excluding corners)
	for x in range(1, GRID_WIDTH - 1):
		generate_wall(x, GRID_HEIGHT - 1, 0, 0, 0, 1)  # (East wall)

	# TOP WALL (excluding corners)
	for y in range(1, GRID_HEIGHT - 1):
		generate_wall(0, y, 1, 0, 0, 0)  # (North wall)

	# BOTTOM WALL (excluding corners)
	for y in range(1, GRID_HEIGHT - 1):
		generate_wall(GRID_WIDTH - 1, y, 0, 0, 1, 0)  # (South wall)

func generate_map():
	var random_sample_spawn
	var random_enemy_spawn
	var prev_x=0
	var prev_y=0
	var cell
	var doorSize_x=6
	var doorSize_y=3
	for x in range(GRID_WIDTH):
		if x>0:
			prev_y+=12
			ROOM_HEIGHT+=12
			doorSize_y+=12
			prev_x=0
			ROOM_WIDTH=19
			doorSize_x=6
		for y in range(GRID_HEIGHT):
			cell=arr[x][y]
			for n in range(prev_x,ROOM_WIDTH):
				for m in range(prev_y, ROOM_HEIGHT):
					
					wallTilesLayer.set_cell(Vector2i(0,0),wallTilesID,topLeft)
					wallTilesLayer.set_cell(Vector2i(0,ROOM_HEIGHT-1),wallTilesID,bottomLeft)
					if n==0 and m%12==0 and m>0:
						wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,topLeft)
						wallTilesLayer.set_cell(Vector2i(n,m-1),wallTilesID,bottomLeft)
					if n%19==0 and m%12==0 and n>0:
						wallTilesLayer.set_cell(Vector2i(n,m),connectTilesID,topJoin)
						wallTilesLayer.set_cell(Vector2i(n-1,m),connectTilesID,topJoin)
						
					if n%19==0 and m==ROOM_HEIGHT-1 and n>0:
						wallTilesLayer.set_cell(Vector2i(n,m),connectTilesID,bottomJoin)
						wallTilesLayer.set_cell(Vector2i(n-1,m),connectTilesID,bottomJoin)
					
					if y==GRID_HEIGHT-1:
						if n==ROOM_WIDTH-1 and m%12==0:
							wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,topRight)
							#wallTilesLayer.set_cell(Vector2i(n,m-1),wallTilesID,bottomRight)
						if n==ROOM_WIDTH-1 and m==ROOM_HEIGHT-1:
							wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,bottomRight)
							

					if cell[0]==0:#NORTH SIDE
						if n>prev_x and n<ROOM_WIDTH-1 and m==prev_y:
							if n>doorSize_x and n<doorSize_x+5:
								wallTilesLayer.set_cell(Vector2i(n,m),levelEndID,levelEndH)
							else:
								wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallH)
					elif cell[0]==1:
						if n>prev_x and n<ROOM_WIDTH-1 and m==prev_y:
							wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallH)

					if cell[1]==0:#WEST SIDE
						if m>prev_y and m<ROOM_HEIGHT-1 and n==prev_x:
							if m>doorSize_y and m<doorSize_y+5:
								wallTilesLayer.set_cell(Vector2i(n,m),levelEndID,levelEndV)
							else:
								wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallV)
					elif cell[1]==1:
						if m>prev_y and m<ROOM_HEIGHT-1 and n==prev_x:
							wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallV)

					if cell[2]==0:#SOUTH SIDE
						if n>prev_x and n<ROOM_WIDTH-1 and m==ROOM_HEIGHT-1:
							if n>doorSize_x and n<doorSize_x+5:
								wallTilesLayer.set_cell(Vector2i(n,m),levelEndID,levelEndH)
							else:
								wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallH)
					elif cell[2]==1:
						if n>prev_x and n<ROOM_WIDTH-1 and m==ROOM_HEIGHT-1:
							wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallH)

					if cell[3]==0:#EAST SIDE
						if m>prev_y and m<ROOM_HEIGHT-1 and n==ROOM_WIDTH-1:
							if m>doorSize_y and m<doorSize_y+5:
								wallTilesLayer.set_cell(Vector2i(n,m),levelEndID,levelEndV)
							else:
								wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallV)
					elif cell[3]==1:
						if m>prev_y and m<ROOM_HEIGHT-1 and n==ROOM_WIDTH-1:
							wallTilesLayer.set_cell(Vector2i(n,m),wallTilesID,wallV)
					
					
			ROOM_WIDTH+=19
			doorSize_x+=19
			prev_x+=19
	pos_x=rng.randi_range(1,GRID_HEIGHT-1)
	pos_y=rng.randi_range(1,GRID_WIDTH-1) 
			
