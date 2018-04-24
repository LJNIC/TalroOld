Player = Class{__includes = Entity}
require 'util'

--player's whip action: pulls an item/mob towards them
function Player:whip(direction)
	for i = 1, 4, 1 do
		dx, dy = multVector(direction.x, direction.y, i, i)
		local bool, e = map:isPassable(self.x + dx, self.y + dy)
		if e ~= nil then --TODO: Call animation with i and the entity
			e.x = self.x + direction.x
			e.y = self.y + direction.y
			break
		elseif bool == false then--TODO: Call animation with just i
			break
		end
	end
end

function Player:animateWhip(direction)
	map:setTile(self.x + direction.x, self.y + direction.y, '~', self.fg)
end
