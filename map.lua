local ROT = require 'lib/rotLove/rot' 
local COLORS = require 'colors'
local gen = require 'generator'
local class = require 'middleclass'
logger = require 'logger'

Map = class('Map')

function Map:initialize(width, height, display)
	self.display = display
	self.map = {}
	self.width = width
	self.height = height
	self.entities = {}
	self.numEntities = 0

	for x = 1, self.width, 1 do
			self.map[x] = {}
		for y = 1, self.height, 1 do
				self.map[x][y] = {symbol = '\32', passable = 1, fg = COLORS.YELLOW, fg = COLORS.YELLOW}
		end
	end
				
	self:drawMap()
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

--checks whether a tile contains a wall or an entity
function Map:isPassable(x, y)
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
		for y = 1, self.display.heightInChars, 1 do
			self.display:write(self.map[x][y].symbol, x, y, self.map[x][y].fg, self.map[x][y].bg)
		end
	end
	--write entities on top	
	for i = 1, self.numEntities, 1 do
		if self.entities[i].x > self.display.widthInChars or
		   self.entities[i].x < 1 or
		   self.entities[i].y > self.display.heightInChars or
		   self.entities[i].y < 1 then
			return 
		end
		self.display:write(self.entities[i].symbol, 
							self.entities[i].x, 
							self.entities[i].y, 
							self.entities[i].fg, 
							self.map[self.entities[i].x][self.entities[i].y].bg)--The map's background at the entity
	end
end

function Map:moveWindow(dx, dy)
end

--renders the map onto the screen
function Map:renderMap()
	self.display:draw()
end

function Map:addEntity(entity)
	self.entities[self.numEntities + 1] = entity
	self.numEntities = self.numEntities + 1
end	
