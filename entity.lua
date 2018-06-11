Entity = {}
--x position, y position, graphic, foreground, background
function Entity:new(x, y, symbol, fg, bg, map)
	e = {}
	setmetatable(e, self)
	self.__index = self
	e.x = x
	e.y = y
	e.symbol = symbol
	e.fg = fg
	e.bg = bg
	e.map = map
	return e
end

function Entity:move(direction)
	if self.map:isPassable(self.x + direction.x, self.y + direction.y) == true then
		self.x = self.x + direction.x
		self.y = self.y + direction.y
		return true
	end
	return false
end

return Entity
