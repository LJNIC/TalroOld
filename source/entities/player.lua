Player = {}

function Player:new(x, y, symbol, fg, bg)
	local p = Entity:new(x, y, symbol, fg, bg)
	p.whip = self.whip
	p.type = 'player'
	p.onHit = self.onHit
	p.shouldMove = self.shouldMove
	return p
end

--player's whip action: pulls an item/mob towards them
function Player:whip(direction)
	for i = 1, 4 do
		dx, dy = Util.multVector(direction.x, direction.y, i, i)
		if not self.map:isPassable(self.x + dx, self.y + dy) then
			local entity = self.map:getEntityAt(self.x + dx, self.y + dy)
			if entity and entity.type ~= 'door' then 
				if entity.type == 'bat' then
					--TODO: Latch onto bat
					table.insert(self.status, 'flying')
				end
				entity.x = self.x + direction.x
				entity.y = self.y + direction.y
				return
			end
			return
		end
	end
end

function Player:shouldMove(direction)
	point = self.map:getDisplayPoint(self.x, self.y)
	if direction.x ~= 0 then
		if direction.x > 0 then
			if self.map.display:getWidth() - point.x < 8 then return true end
			return false
		else
			if point.x < 8 then return true end
			return false
		end
	else
		if direction.y > 0 then
			if self.map.display:getHeight() - point.y < 8 then return true end
			return false
		else
			if point.y < 8 then return true end
			return false 
		end
	end
end
	
	

function Player:onHit(other)
	Logger.log('Player hit an entity', 3)
	if other.type == 'mummy' then
		self.map:removeEntity(other)
	elseif other.type == 'door' then
		Logger.log("Hit door", 3)
		self.map:removeEntity(self)
		self.x = other.nextX
		self.y = other.nextY
		self.map = other.nextMap
		self.mapChanged = true
		self.map:addEntity(self)
	end
end
	
return Player
