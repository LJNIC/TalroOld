Entity = Class{}
--x position, y position, graphic, foreground, background
function Entity:init(x, y, symbol, fg, bg, map)
	self.x = x
	self.y = y
	self.symbol = symbol
	self.fg = fg
	self.bg = bg
	self.map = map
	self.map:addEntity(self)
end

function Entity:move(dx, dy)
	if self.map:isPassable(self.x + dx, self.y + dy) == true then
		self.x = self.x + dx
		self.y = self.y + dy
	end 
end
