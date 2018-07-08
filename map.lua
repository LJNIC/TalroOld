--[[
The map keeps track of the entities, walls, obstacles etc in the game.
Entities are stored as a list of uuid, entity pairs.
The map can be moved around and drawn from different points.
The map's display is controlled by rotLove's display class.
--]]
--
Map = {}

--Creates a map. A display is a rotLove Display class.
function Map:new(width, height, display)
	m = {}
	m.seen = {}
	m.fov = {}
	m.display = display 
	m.map = {}
	m.width = width
	m.height = height
	m.entities = {}
	m.x = 0
	m.y = 0

	for x = 1, m.width do
		m.map[x] = {}
		for y = 1, m.height do
			m.map[x][y] = {seen = false, tile = TileTypes.Floor}
		end
	end
	setmetatable(m, self)
	self.__index = self
	return m
end

--Resets any visible tiles to not visible
function Map:resetFOV()
	for x = 1, self.width do
		for y = 1, self.height do
			self.map[x][y].visible = false
		end
	end
end

--Sets a tile to visible
function Map:visible(x, y)
	if not self:isInside(x, y) then return end
	self.map[x][y].visible = true
end

--Sets a tile to be seen.
function Map:see(x, y)
	if not self:isInside(x, y) then return end
	self.map[x][y].seen = true
end

--sets a tile, only x and y are non-optional
function Map:setTile(x, y, tileType)
	if not self:isInside(x, y) then return end
	self.map[x][y].tile = tileType	
end

function Map:shouldMove(x, y)
	local x, y = self:getDisplayPoint(x, y)
end

--Returns whether a point is inside the map or not. 
function Map:isInside(x, y)
	return x <= self.width and x > 0 and y <= self.height and y > 0 
end

--checks whether a tile contains a wall or an entity
function Map:isPassable(x, y)
	--If the point is outside the map
	--
	if not self:isInside(x, y) then return end

	Logger.log(self.map[x][y].tile.passable, 1)
	--If there's an entity in the way
	if self.map[x][y].tile.passable == 0 then
		for _,entity in pairs(self.entities) do
			if x == entity.x and y == entity.y then
				return false 
			end
		end
		return true
	else
		return false
	end
end

--Returns nil or the entity at the given position
function Map:getEntityAt(x, y)
	for _,entity in pairs(self.entities) do
		if x == entity.x and y == entity.y then
			return entity
		end
	end
end
	
--writes the characters to the object, not to screen
function Map:drawMap()

	--write the terrain
	for x = 1, self.display.widthInChars do
		for y = 1, self.display.heightInChars do
			local shiftX, shiftY = x + self.x, y + self.y
			if self.map[x][y].visible then
				self.display:write(self.map[shiftX][shiftY].tile.symbol, x, y, self.map[shiftX][shiftY].tile.visiblefg)

			elseif self.map[x][y].seen then

				self.display:write(self.map[shiftX][shiftY].tile.symbol, x, y, self.map[shiftX][shiftY].tile.seenfg)
			end
		end
	end

	for _,entity in pairs(self.entities) do
		--Check if the entity is non-nil or if the entity is outside of the display area
		if self.map[entity.x][entity.y].visible then
			if entity.x == nil or not self:isInside(entity.x, entity.y) then
				return 
			else
				--Draw the entity
				self.display:write(entity.symbol, 
								entity.x - self.x, 
								entity.y - self.y, 
								entity.fg, 
								self.map[entity.x][entity.y].tile.visiblebg)--The map's background at the entity
			end
		end
	end
end

--Draws a CSV file at the given points and which characters are passable
function Map:drawCSV(x, y, csvfile, passables)
	local tiles = Util.parseCSV(csvfile)
	for _,tile in pairs(tiles) do
		local pass = 1
		for _, character in pairs(passables) do
			if tile.char == character then
				pass = 0
			end
		end
		self:setTile(tile.x + x - 1, tile.y + y-1, tile.char, pass, tile.fore, tile.back)
	end
	self:drawMap()
end

--Returns the x and y translated to its actual display position
function Map:getDisplayPoint(x, y)
	if x < self.x + self.display.widthInChars and
	   x > self.x and
	   y > self.y and
	   y < self.y + self.display.heightInChars then
	   	return x - self.x, y - self.y
	end
end

--Moves the map so that it's drawn at a different point,
--but not if there won't be any map to draw.
function Map:move(direction)	
	if self.x + self.display.widthInChars + direction.x > self.width or
	   self.y + self.display.heightInChars + direction.y > self.height or
	   self.x + direction.x < 0 or 
	   self.y + direction.y < 0 then
	   	return
	end
	self.x = self.x + direction.x
	self.y = self.y + direction.y
end

--Renders the map onto the screen
function Map:renderMap()
	self.display:draw()
end

--Adds the entity to the map
function Map:addEntity(entity)
	assert(type(entity) == 'table' and entity.uuid, "Not an entity!")
	Logger.log('Added entity of type ' .. entity.type, 3)
	self.entities[entity.uuid] = entity
end	

--Removes the entity from the map if it matches a uuid
function Map:removeEntity(entity)
	assert(type(entity) == 'table' and entity.uuid, "Not an entity!")
	for uuid in pairs(self.entities) do
		if uuid == entity.uuid then
			Logger.log('Removed entity of type ' .. entity.type, 3)
			self.entities[uuid] = nil
			return;
		end
	end
end

return Map
