Mummy = {}

function Mummy:new(x, y, symbol, fg, bg, map)
	m = Entity:new(x, y, symbol, fg, bg, map)
	m.type = 'mummy'
	return m
end

return Mummy
