Map = {}

function Map:new(width, height, display)
	m = {}
	m.display = display 
	m.map = {}
	m.width = width
	m.height = height
	m.entities = {}
	m.x = 0
	m.y = 0
	
	for x = 1, m.width, 1 do
			m.map[x] = {}
		for y = 1, m.height, 1 do
				m.map[x][y] = {symbol = '\32', passable = 1, fg = COLORS.YELLOW, fg = COLORS.YELLOW}
		end
	end

	setmetatable(m, self)
	self.__index = self
	return m
end

--sets a tile, only x and y are non-optional
function Map:setTile(x, y, symbol, passable, fg, bg)
	local symbol = symbol or self.map[x][y].symbol
	local pass = passable or self.map[x][y].passable
	local fg = fg or self.map[x][y].fg
	local bg = bg or self.map[x][y].bg

	self.map[x][y].symbol = symbol
	self.map[x][y].passable = passable
	self.map[x][y].fg = fg
	self.map[x][y].bg = bg
end

function Map:shouldMove(x, y)
	local x, y = self:getDisplayPoint(x, y)
end

--checks whether a tile contains a wall or an entity
function Map:isPassable(x, y)
	--If the point is outside the map
	if x > self.width or x < 1
	   or y > self.height or y < 1 then
	   return false
	end
	--If there's an entity in the way
	if self.map[x][y].passable == 0 then
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
			self.display:write(self.map[x+self.x][y+self.y].symbol, x, y, self.map[x+self.x][y+self.y].fg, self.map[self.x+x][self.y+y].bg)
		end
	end

	for _,entity in pairs(self.entities) do
		local shouldDraw = true
		--Check if the entity is non-nil or if the entity is outside of the display area
		if entity.x == nil or (entity.x > self.x + self.display.widthInChars or
		   entity.x < 1 + self.x or
		   entity.y > self.y + self.display.heightInChars or
		   entity.y < self.y + 1) then
		   shouldDraw = false
		end

		--Draw the entity
		if shouldDraw then
			self.display:write(entity.symbol, 
							entity.x - self.x, 
							entity.y - self.y, 
							entity.fg, 
							self.map[entity.x][entity.y].bg)--The map's background at the entity
		end
	end
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

--Moves the map so that it's drawn at a different point
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

--renders the map onto the screen
function Map:renderMap()
	self.display:draw()
end

--Adds the entity to the map
function Map:addEntity(entity)
	assert(type(entity) == 'table' and entity.uuid, "Not an entity!")
	Logger.log('Added entity of type ' .. entity.type, 3)
	self.entities[entity.uuid] = entity
end	

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
