ROT = require 'lib/rotLove/rot' 
COLORS = require 'colors'
Class = require 'class'
require 'entity'
require 'map'
require 'player'

SCREEN_HEIGHT = 45
SCREEN_WIDTH = 78

moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
actionKeys = {['t'] = true}

map = {}
entities = {}
numEntities = 0

function love.load()
	--Setup tileset / display
	local spriteSheet = love.graphics.newImage('Cheepicus_8x8x2.png') map = Map(SCREEN_WIDTH, SCREEN_HEIGHT, root, spriteSheet)
	player = Player(4, 4, '@', COLORS.MAROON, COLORS.YELLOW, map)
	enemy = Entity(5, 5, 'T', COLORS.GREEN, COLORS.YELLOW, map)
	--parsing the start screen file: x position, y position, character, foreground, background
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
	end
	gameState = 'playing'

end

function love.keypressed(key)
end

function love.textinput(t)
-- TODO: Handle input
	if gameState == 'playing' then
		if moveKeys[t] then
			player:move(keyToDirection(t))
		end
	end
end

function keyToDirection(key)
	if key == 'w' then
		return {x=0, y=-1}
	elseif key == 'd' then
		return {x=1, y=0}
	elseif key == 's' then
		return {x=0, y=1}
	elseif key == 'a' then
		return {x=-1, y=0}
	end
end

function love.update()	
	--Draws characters on the virtual terminal but not the screen
	map:drawMap()
end

function love.draw() 
	map:renderMap()
end
