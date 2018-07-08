Door = {}

function Door:new(x, y, symbol, fg, bg, map, nextMap)
	d = Entity:new(x, y, symbol, fg, bg, map)
	d.type = 'door'
	d.nextMap = nextMap
	return d
end

return Door
