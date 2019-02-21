TileTypes = require 'util/tile-types'
--[[
The map keeps track of the entities, walls, obstacles etc in the game.
Entities are stored as a list of uuid, entity pairs.
The map can be moved around and drawn from different points.
The map's display is controlled by rotLove's display class.
--]]
local Map = {}

--Creates a map. A display is a rotLove Display class.
function Map:new(width, height, display)
	m = {}
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

--Returns the x and y translated to its actual display position
function Map:getDisplayPoint(x, y)
	return {x = x - self.x, y =  y - self.y}
end

--Returns whether a point is inside the map or not 
function Map:contains(x, y)
	return x <= self.width and x > 0 and y <= self.height and y > 0 
end

--Returns whether a translated point is inside the display or not
function Map:displayContains(x, y)
	local point = self:getDisplayPoint(x, y)
	return self.display:contains(point.x, point.y)
end

--Sets a tile to visible
function Map:visible(x, y)
	if not self:contains(x, y) then return end
	self.map[x][y].visible = true
end

--Sets a tile to seen
function Map:see(x, y)
	if not self:contains(x, y) then return end
	self.map[x][y].seen = true
end

--Returns whether the tile is visible
function Map:isVisible(x, y)
	return self.map[x][y].visible
end

--sets a tile, only x and y are non-optional
function Map:setTile(x, y, tileType)
	if not self:contains(x, y) then return end
	self.map[x][y].tile = tileType	
end

function Map:centerOn(x, y)
	if not self:contains(x, y) then return end
	
end

function Map:getEntityInDirection(direction, position)
	for i = 1, 4 do
		local dx, dy = Util.multVector(direction.x, direction.y, i, i)
		if not self.map:isPassable(position.x + dx, position.y + dy) then
			return self:getEntityAt(position.x + dx, position.y + dy)
		end
	end
end

--return location of player
function Map:getPlayer()
	for _,entity in pairs(self.entities) do
		if entity.type == 'player' then
			return {x=entity.x, y=entity.y}
		end
	end
end

--checks whether a tile contains a wall or an entity
function Map:isPassable(x, y)
	--If the point is outside the map
	--
	if not self:contains(x, y) then return end

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
	
--writes the characters to the display canvas, not to screen
function Map:drawMap()

	self.display:clear()
	--write the terrain
	for x = 1, self.display:getWidth() do
		for y = 1, self.display:getHeight() do
			local shiftX, shiftY = x + self.x, y + self.y
			if self.map[shiftX][shiftY].visible then
				self.display:write(self.map[shiftX][shiftY].tile.symbol, x, y, self.map[shiftX][shiftY].tile.visiblefg)
			elseif self.map[shiftX][shiftY].seen then
				self.display:write(self.map[shiftX][shiftY].tile.symbol, x, y, self.map[shiftX][shiftY].tile.seenfg)
			end
		end
	end

	for _,entity in pairs(self.entities) do
		--Check if the entity is visible and inside the display
		if self.map[entity.x][entity.y].visible and self:displayContains(entity.x, entity.y) then
			--Draw the entity
			self.display:write(entity.symbol, 
							   entity.x - self.x,
							   entity.y - self.y,
							   entity.fg)
		end
	end
end

--Draws a CSV file at the given points and which characters are passable
function Map:drawCSV(x, y, csvfile, passables)
	local tiles = Util.parseCSV(csvfile)
	for _,tile in pairs(tiles) do
		local pass = 1
		for _,character in pairs(passables) do
			if tile.char == character then
				pass = 0
			end
		end
		self:setTile(tile.x + x - 1, tile.y + y-1, tile.char, pass, tile.fore, tile.back)
	end
	self:drawMap()
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
	entity.map = self
	self.entities[entity.uuid] = entity
end	

--Removes the entity from the map if it matches a uuid
function Map:removeEntity(entity)
	assert(type(entity) == 'table' and entity.uuid, "Not an entity!")
	if self.entities[entity.uuid] then 
		self.entities[entity.uuid].map = nil
		self.entities[entity.uuid] = nil
	end
end

--Call every entity in the map's ai function
function Map:computeAI()
	for _,entity in pairs(self.entities) do
		if entity.ai then
			entity:ai()
		end
	end
end

return Map
