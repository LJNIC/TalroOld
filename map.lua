ROT = require 'lib/rotLove/rot' 
COLORS = require 'colors'
Map = Class{}

function Map:init(width, height, display, spriteSheet)
	self.display = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 1, spriteSheet, 16, 16)
	self.map = {}
	self.entities = {}
	self.numEntities = 0
	for x = 1, width, 1 do
		self.map[x] = {}
		for y = 1, height, 1 do
			--passable: 1 for false, 0 for true
			self.map[x][y] = {symbol = 'H', passable = 1, fg = COLORS.YELLOW, bg = COLORS.YELLOW}
		end
	end
	self:drawMap()
end

function Map:setTile(x, y, symbol, passable, fg, bg)
	local symbol = symbol or map[x][y].symbol
	local pass = passable or map[x][y].passable
	local fg = fg or map[x][y].fg
	local bg = bg or map[x][y].bg

	map[x][y].symbol = symbol
	map[x][y].passable = passable
	map[x][y].fg = fg
	map[x][y].bg = bg
end

function Map:isPassable(x, y)
	if map[x][y].passable == 0 then
		return true
	else
		return false
	end
end

function Map:drawMap()
	for x = 1, SCREEN_WIDTH, 1 do
		for y = 1, SCREEN_HEIGHT, 1 do
			self.display:write(self.map[x][y].symbol, x, y, self.map[x][y].fg, self.map[x][y].bg)
		end
	end
end

function Map:getDisplay()
	return self.display
end

function Map:renderMap()
	self.display:draw()
end

function Map:addEntity(entity)
	self.entities[numEntities + 1] = entity
	self.numEntities = self.numEntities + 1
end	
