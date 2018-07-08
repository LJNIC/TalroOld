--[[
The mummy is essentially a zombie. Moves slower than the player but can grab
the player from a distance with its straps. Only moves orthogonally.
--]]	
Mummy = {}

function Mummy:new(x, y, symbol, fg, bg, map)
	m = Entity:new(x, y, symbol, fg, bg, map)
	m.type = 'mummy'
	m.ai = self.ai 
	return m
end

function Mummy:ai()
	--Pathfinding: Target player when in player's FOV, if not move randomly
	if self.map:isVisible(self.x, self.y) then
		local player = self.map:getPlayer()
		local dx = player.x - self.x
		local dy = player.y - self.y
		if math.abs(dx) > math.abs(dy) then
			if self:canMove({x=1, y=0}) then
				self:move({x=1, y=0})
			elseif self:canMove({x=-1, y=0}) then
				dx = -1
			end
		else
			
		end
		dx = Util.round(dx / distance)
		dy = Util.round(dy / distance) 
		self:move(dx, dy)
	else
		local axis = (math.random() > 0.5) and 'x' or 'y'
		local direction = (math.random() > 0.5) and 1 or -1
		if axis == 'x' then
			self:move({x=direction, y=0})
		else
			self:move({x=0, y=direction})
		end
	end
end

function Mummy:grab(direction)
	for i = 1, 4 do
		dx, dy = Util.multVector(direction.x, direction.y, i, i)
		if not self.map:isPassable(self.x + dx, self.y + dy) then
			local entity = self.map:getEntityAt(self.x + dx, self.y + dy)
			if entity and entity.type ~= 'door' then 
				entity.x = self.x + direction.x
				entity.y = self.y + direction.y
				return
			end
		end
	end
end
	

return Mummy
