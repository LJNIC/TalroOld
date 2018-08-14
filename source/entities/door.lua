Door = {}

--The door entity requires a map that it points to, and what position on that map
function Door:new(x, y, symbol, fg, bg, nextMap, nextX, nextY)
	local d = Entity:new(x, y, symbol, fg, bg)
	d.type = 'door'
	d.nextMap = nextMap
	d.nextX = nextX
	d.nextY = nextY
	return d
end

return Door
