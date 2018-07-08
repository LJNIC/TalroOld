Mummy = {}

function Mummy:new(x, y, symbol, fg, bg, map)
	m = Entity:new(x, y, symbol, fg, bg, map)
	m.type = 'mummy'
	m.ai = self.ai 
	return m
end

function Mummy:ai()
	math.randomseed(os.time())
	local axis = (math.random() > 0.5) and 'x' or 'y'
	local direction = (math.random() > 0.5) and 1 or -1
	if axis == 'x' then
		self:move({x=direction, y=0})
	else
		self:move({x=0, y=direction})
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
