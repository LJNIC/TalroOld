local class = require 'middleclass'

Entity = class('Person')

--x position, y position, graphic, foreground, background
function Entity:initialize(x, y, symbol, fg, bg, map)
	self.x = x
	self.y = y
	self.symbol = symbol
	self.fg = fg
	self.bg = bg
	self.map = map
	self.map:addEntity(self)
end

function Entity:move(direction)
	if self.map:isPassable(self.x + direction.x, self.y + direction.y) == true then
		self.x = self.x + direction.x
		self.y = self.y + direction.y
	end
end
