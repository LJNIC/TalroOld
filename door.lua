Door = {}

function Door:new(x, y, symbol, fg, bg, map)
	d = Entity:new(x, y, symbol, fg, bg, map)
	d.type = 'door'
end

return Door
