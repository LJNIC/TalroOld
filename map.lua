ROT = require 'lib/rotLove/rot' 
COLORS = require 'colors'
generator = require 'generator'
Map = Class{}

function Map:init(width, height, spriteSheet)
	self.display = ROT.Display:new(width, height, 1, spriteSheet, 16, 16)
	self.map = {}

	--generate a tunnel: width, height, tunnel length, roughness, windyness, max width, 
	--whether to start at bottom or top 
	local generated = generator.generateTunnel(width, height, 45, 20, 20, 10, true)
	self.width = width
	self.height = height
	self.entities = {}
	self.numEntities = 0
	for x = 1, self.width, 1 do
			self.map[x] = {}
		for y = 1, self.height, 1 do
				self.map[x][y] = {symbol = '\32', passable = 1, fg = COLORS.YELLOW, fg = COLORS.YELLOW}
				self:setTile(x, y, '\32', 1, COLORS.YELLOW, COLORS.YELLOW)
			if generated[x][y] == ' ' then
				self:setTile(x, y, '\176', 0, COLORS.LIGHT_YELLOW, COLORS.YELLOW)
			end
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
		for i = 2, self.numEntities, 1 do --skip 1 because that will always be the player
			if x == self.entities[i].x and y == self.entities[i].y then
				return false, self.entities[i]
			else
				return true
			end
		end
	else
		return false
	end
end

--writes the characters to the object, not to screen
function Map:drawMap()
	--write the terrain
	for x = 1, self.width, 1 do
		for y = 1, self.height, 1 do
			self.display:write(self.map[x][y].symbol, x, y, self.map[x][y].fg, self.map[x][y].bg)
		end
	end
	--write entities on top	
	for i = 1, self.numEntities, 1 do
		self.display:write(self.entities[i].symbol, 
							self.entities[i].x, 
							self.entities[i].y, 
							self.entities[i].fg, 
							self.map[self.entities[i].x][self.entities[i].y].bg)
	end
end

--renders the map onto the screen
function Map:renderMap()
	self.display:draw()
end

function Map:addEntity(entity)
	self.entities[self.numEntities + 1] = entity
	self.numEntities = self.numEntities + 1
end	
