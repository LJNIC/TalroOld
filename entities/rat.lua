--Rats are small, quick, and travel in packs.
Rat = {}

function Rat:new(x, y, symbol, fg, bg, map)
	local r = Entity:new(x, y, symbol, fg, bg, map)
	r.type = 'rat'
	return r
end

function Rat:ai()
	--TODO Rat AI. They should travel in packs and attack the player but run away frequently.
end
