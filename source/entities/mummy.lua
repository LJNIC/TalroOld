--[[
The mummy is essentially a zombie. Moves slower than the player but can grab
the player from a distance with its straps. Only moves orthogonally.
--]]	
local Mummy = {}

function Mummy:new(x, y, symbol, fg, bg, map)
	local m = Entity:new(x, y, symbol, fg, bg, map)
	m.type = 'mummy'
	m.ai = self.ai 
	m.turn = true
	m.lastpath = nil
	m.pathcount = 0
	m.range = 5
	m.grab = self.grab
	m.grabCooldown = 0
	return m
end

function Mummy:ai()
	--Pathfinding: Target player when in player's FOV, if not move randomly
	if self.map.map[self.x][self.y].visible and self.turn then
		local player = self.map:getPlayer()

		--Check if player is within range to grab and grab them if they are
		local dx = player.x - self.x
		local dy = player.y - self.y
		if dx == 0 and math.abs(dy) < self.range and self.grabCooldown == 0 then
			self:grab({x=0, y = (dy > 0) and 1 or -1})
			self.grabCooldown = 4
			self.turn = not self.turn
			return
		elseif dy == 0 and math.abs(dx) < self.range and self.grabCooldown == 0 then
			self:grab({x = (dx > 0) and 1 or -1, y=0})
			self.grabCooldown = 4
			self.turn = not self.turn
			return
		end

		self.pathcount = 0	
		self.lastpath = AStar:find(self.map.width, self.map.height, self, player, 
			function(x, y) return self.map.map[x][y].tile.passable == 0 end, false)

		--Get the second tile in the path because the first is the mummy
		local to = self.lastpath[2]
		self.pathcount = self.pathcount + 1	
		self:move({x = to.x - self.x, y = to.y - self.y})
	elseif self.turn then
		--If the player is out of view but the mummy hasn't reached their last location, continue on it
		if self.lastpath and self.pathcount + 2 < #self.lastpath then
			local to = self.lastpath[2 + self.pathcount]
			self.pathcount = self.pathcount + 1
			self:move({x = to.x - self.x, y = to.y - self.y})
		--If the player is out of view and the mummy has reached the last location, wander randomly
		else
			local axis = (math.random() > 0.5) and 1 or -1	
			local direction = (math.random() > 0.5) and 1 or -1
			self:move({x = axis == 1 and direction or 0, y = axis == -1 and direction or 0})
		end
	end

	if self.grabCooldown > 0 then
		self.grabCooldown = self.grabCooldown - 1
	end

	Logger.log('Mummy grab cooldown: ' .. self.grabCooldown, 3)
		
	--Toggle whether the mummy takes a turn to make them go half as fast
	self.turn = not self.turn
end

function Mummy:grab(direction)
	Logger.log('Mummy grabbed player!', 3)
	for i = 1, 4 do
		dx, dy = Util.multVector(direction.x, direction.y, i, i)
		if not self.map:isPassable(self.x + dx, self.y + dy) then
			local entity = self.map:getEntityAt(self.x + dx, self.y + dy)
			if entity and entity.type ~= 'door' then 
				entity.x = self.x + direction.x
				entity.y = self.y + direction.y
				return
			end
			return
		end
	end
end

return Mummy
