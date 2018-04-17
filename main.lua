ROT = require 'lib/rotLove/rot' 
COLORS = require 'colors'
Class = require 'class'
require 'player'

SCREEN_HEIGHT = 45
SCREEN_WIDTH = 78

map = {}
entities = {}
numEntities = 0

function love.load()
	--Setup tileset / display
	spriteSheet = love.graphics.newImage('Cheepicus_8x8x2.png')
	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 1, spriteSheet, 16, 16)
	player = Player(4, 4, '@', COLORS.MAROON, COLORS.YELLOW)
	for x = 1, SCREEN_WIDTH, 1 do
		map[x] = {}
		for y = 1, SCREEN_HEIGHT, 1 do
			--passable: 1 for false, 0 for true
			map[x][y] = {symbol = ' ', passable = 1, fg = COLORS.YELLOW, bg = COLORS.YELLOW}
		end
	end
	--parsing the start screen file
	for line in io.lines('pyramid.csv') do
		local tempTile = {}
		local i = 1
		for word in string.gmatch(line, '([^,]+)') do
    		tempTile[i] = word
			i = i + 1
		end
		local x = tonumber(tempTile[1])
		local y = tonumber(tempTile[2])
		local char = string.char(tempTile[3])
		local fore = ROT.Color.fromString(tempTile[4])
		local back = ROT.Color.fromString(tempTile[5])
		local pass = 1
		if char == '\176' then
			pass = 0
		end
		setTile(x, y, char, pass, fore, back)
	end

	while inBounds == false do
		playerx = love.math.random(SCREEN_WIDTH)
		playery = love.math.random(SCREEN_HEIGHT)
		if isPassable(playerx, playery) then
			inBounds = true
		end
	end
    drawMap()
end

function addEntity(entity)
	entities[numEntities + 1] = entity
	numEntities = numEntities + 1
end	

function setTile(x, y, symbol, passable, fg, bg)
	local symbol = symbol or map[x][y].symbol
	local pass = passable or map[x][y].passable
	local fg = fg or map[x][y].fg
	local bg = bg or map[x][y].bg
	map[x][y].symbol = symbol
	map[x][y].passable = passable
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
-- TODO: Handle input
end

function isPassable(x, y)
	if map[x][y].passable == 0 then
		return true
	else
		return false
	end
end

function love.update()	
end

function love.draw() 
	root:draw()
end
