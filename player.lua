Player = Class{__includes = Entity}
require 'util'

--player's whip action: pulls an item/mob towards them
function Player:whip(direction)
	for i = 1, 4, 1 do
		dx, dy = multVector(direction.x, direction.y, i, i)
		local bool, e = map:isPassable(self.x + dx, self.y + dy)
		if e ~= nil then
			e.x = self.x + direction.x
			e.y = self.y + direction.y
			break
		elseif bool == false then
			break
		end
	end
end
