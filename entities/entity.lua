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
	e.uuid = UUID()
	return e
end

--Moves the entity by a vector {x=, y=}
function Entity:move(direction)
	Logger.log('Entity tried to move', 1)
	if self.map:isPassable(self.x + direction.x, self.y + direction.y) == true then
		Logger.log('Entity moved', 1)
		self.x = self.x + direction.x
		self.y = self.y + direction.y
		return true
	elseif self.map:getEntityAt(self.x + direction.x, self.y + direction.y) ~= nil then
		local hit = self.map:getEntityAt(self.x + direction.x, self.y + direction.y)
		self:onHit(hit)
		return true
	end
	return false
end

--entities should override these functions
function Entity:onHit(other) return end
function Entity:onDefend(other) return end

return Entity
