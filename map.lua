Map = {}

function Map:new(width, height, display)
	m = {}
	m.display = display 
	m.map = {}
	m.width = width
	m.height = height
	m.entities = {}
	m.numEntities = 0
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
	if x > self.width or x < 1
	   or y > self.height or y < 1 then
	   return false
	end
	if self.map[x][y].passable == 0 then
		for i = 1, self.numEntities, 1 do --skip 1 because that will always be the player
			if x == self.entities[i].x and y == self.entities[i].y then
				return false 
			else
				return true
			end
		end
	else
		return false
	end
end

function Map:getEntityAt(x, y)
	for i = 1, self.numEntities do
		if x == self.entities[i].x and y == self.entities[i].y then
			return self.entities[i]
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
	--write entities on top	
	for i = 1, self.numEntities, 1 do
		if self.entities[i].x > self.x + self.display.widthInChars or
		   self.entities[i].x < 1 + self.x or
		   self.entities[i].y > self.y + self.display.heightInChars or
		   self.entities[i].y < self.y + 1 then
			return 
		end

		self.display:write(self.entities[i].symbol, 
							self.entities[i].x - self.x, 
							self.entities[i].y - self.y, 
							self.entities[i].fg, 
							self.map[self.entities[i].x][self.entities[i].y].bg)--The map's background at the entity
	end
end

function Map:getDisplayPoint(x, y)
	if x < self.x + self.display.widthInChars and
	   x > self.x and
	   y > self.y and
	   y < self.y + self.display.heightInChars then
	   	return x - self.x, y - self.y
	end
end

function Map:moveWindow(direction)	
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

function Map:addEntity(entity)
	self.entities[self.numEntities + 1] = entity
	self.numEntities = self.numEntities + 1
end	

return Map
