ROT = require 'lib/rotLove/rot' 
COLORS = require 'colors'
SCREEN_HEIGHT = 25
SCREEN_WIDTH = 25

map = {}
player = {}

function love.load()
	spriteSheet = love.graphics.newImage('Cheepicus_8x8x2.png')
	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 1, false, 0, spriteSheet, 16, 16)
	fov = ROT.FOV.Precise:new(lightCallback)

	while inBounds == false do
		playerx = love.math.random(SCREEN_WIDTH)
		playery = love.math.random(SCREEN_HEIGHT)
		if isPassable(playerx, playery) then
			inBounds = true
		end
	end
	player = {x = playerx, y = playery, symbol = '@', fg = white}
    drawMap()
end

function setTile(x, y, symbol, passable, fg, bg)
	local symbol = symbol or map[x][y].symbol
	local pass = map[x][y].passable
	if passable ~= nil then
		pass = passable	
	end
	local fg = fg or map[x][y].fg
	local bg = bg or map[x][y].bg
	map[x][y].symbol = symbol
	map[x][y].passable = pass
	map[x][y].fg = fg
	map[x][y].bg = bg
end
	

function drawMap()
	for x = 1, SCREEN_WIDTH, 1 do
		for y = 1, SCREEN_HEIGHT, 1 do
			root:write(map[x][y].symbol, x, y, map[x][y].fg, map[x][y].bg)
		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.textinput(t)
end

function isPassable(x, y)
	return map[x][y].passable
end

function love.update()	
	root:write(player.symbol, player.x, player.y, player.fg, map[player.x][player.y].bg)		
end

function love.draw() 
	root:draw()
	root:write(map[player.x][player.y].symbol, player.x, player.y, map[player.x][player.y].fg, map[player.x][player.y].bg)
end
