--The bat moves erratically (only diagonally) but doesn't attack the player.
Bat = {}

function Bat:new(x, y, symbol, fg, bg)
	local b = Entity:new(x, y, symbol, fg, bg)
	b.type = 'bat'
	b.ai = self.ai 
	return b
end

function Bat:ai()
	local x = (math.random() > 0.5) and 1 or -1
	local y = (math.random() > 0.5) and 1 or -1
	if self:canMove({x=x, y=y}) then
		self:move({x=x, y=y})
	elseif self:canMove({x=y, y=x}) then
		self:move({x=x, y=y}) 
	end
end

return Bat
