Player = {}

function Player:new(x, y, symbol, fg, bg, map)
	p = Entity:new(x, y, symbol, fg, bg, map)
	p.whip = self.whip
	p.type = 'player'
	p.onHit = self.onHit
	return p
end

--player's whip action: pulls an item/mob towards them
function Player:whip(direction)
	for i = 1, 4 do
		dx, dy = Util.multVector(direction.x, direction.y, i, i)
		if not self.map:isPassable(self.x + dx, self.y + dy) then
			local entity = self.map:getEntityAt(self.x + dx, self.y + dy)
			if entity ~= nil then 
				entity.x = self.x + direction.x
				entity.y = self.y + direction.y
				return
			end
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
