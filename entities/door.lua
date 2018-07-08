Door = {}

--The door entity requires a map that it points to, and what position on that ma[
function Door:new(x, y, symbol, fg, bg, map, nextMap, nextX, nextY)
	d = Entity:new(x, y, symbol, fg, bg, map)
	d.type = 'door'
	d.nextMap = nextMap
	d.nextX = nextX
	d.nextY = nextY
	return d
end

return Door
