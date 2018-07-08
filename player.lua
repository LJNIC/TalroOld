Player = Class{__includes = Entity}
require 'util'
logger = require 'logger'

--player's whip action: pulls an item/mob towards them
function Player:whip(direction)
	for i = 1, 4 do
		dx, dy = multVector(direction.x, direction.y, i, i)
		if not map:isPassable(self.x + dx, self.y + dy) then
			local entity = map:getEntityAt(self.x + dx, self.y + dy)
			if entity ~= nil then 
				entity.x = self.x + direction.x
				entity.y = self.y + direction.y
				return
			end
		end
	end
end

function Player:animateWhip(direction)
	map:setTile(self.x + direction.x, self.y + direction.y, '~', self.fg)
end
