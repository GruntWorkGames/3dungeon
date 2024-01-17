class_name FloorFactory extends Node

# true == wall
# false == open space 
func generate(size, numOpenTiles):
	var floordata = _fillFloorArray(size)

	# set controller in center
	var cx = size.x / 2
	var cy = size.z / 2
	
	var r = RandomNumberGenerator.new()

	# rand direction
	var cdir = r.randi_range(0,3)
	
	# odds of changing direction
	#var odds = 3
	
	#create using x steps
	var numTiles = 0
	
	while(numTiles < numOpenTiles):
		# place a floor tile at controller pos
		# if we havent already been in this tile, count it as placing a new one.
		if(floordata[cx][cy]):
			numTiles += 1
		floordata[cx][cy] = false
		
		#randomize direction
		if r.randi_range(0,2) == 2:
			cdir = r.randi_range(0,3)
			
		# move the controller
		var xdir = _lengthdir_x(1, cdir * 90)
		var ydir = _lengthdir_y(1, cdir * 90)
		
		# random if y or x gets changed, but cant go both directions
		if r.randi_range(0,1) == 0:
			cx += xdir
		else:	
			cy += ydir
		
		cx = clamp(cx, 1, size.x - 2)
		cy = clamp(cy, 1, size.z - 2)
	return floordata

func _fillFloorArray(size):
	var floordata = []
	for x in size.x:
		var wallsz = []
		floordata.append(wallsz)
		for z in size.z:
			floordata[x].append(true)
	return floordata

func _lengthdir_x(length, angle):
	return cos(angle * (3.14 / 180) * length)

func _lengthdir_y(length, angle):
	return sin(angle * (3.14 / 180) * length)
