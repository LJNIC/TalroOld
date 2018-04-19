Entity = Class{}
--x position, y position, graphic, foreground, background
function Player:init(x, y, symbol, fg, bg, map)
	self.x = x
	self.y = y
	self.symbol = symbol
	self.fg = fg
	self.bg = bg
	self.map = map
end

function Player:move(dx, dy)

end

