require 'util'
local class = require 'lib/middleclass'

Player = class('Player')

function Player:initialize(x, y, symbol, fg, bg, map)
	self.x = x
	self.y = y
	self.symbol = symbol
	self.fg = fg
	self.bg = bg
	self.map = map
	self.map:addEntity(self)
end

function Player:move(direction)
	if self.map:isPassable(self.x + direction.x, self.y + direction.y) == true then
		self.x = self.x + direction.x
		self.y = self.y + direction.y
		return true
	end
	return false
end

--player's whip action: pulls an item/mob towards them
function Player:whip(direction)
	for i = 1, 4 do
		dx, dy = multVector(direction.x, direction.y, i, i)
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

function Player:animateWhip(direction)
	map:setTile(self.x + direction.x, self.y + direction.y, '~', self.fg)
end
