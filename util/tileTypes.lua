tileTypes = {}
function tileTypes:newTile(tileType, seenfg, visiblefg, passable, symbol)
	t = {}
	t.tileType = tileType
	t.seenfg = seenfg
	t.visiblefg = visiblefg
	t.symbol = symbol
	t.passable = passable
	self[tileType] = t
end

tileTypes:newTile('Floor', COLORS.GREY, COLORS.WHITE, 0, '\13')
tileTypes:newTile('Wall', COLORS.GREY, COLORS.YELLOW, 1, '\18')
tileTypes:newTile('Hero', COLORS.WHITE, COLORS.WHITE , 1, '\35')

return tileTypes
