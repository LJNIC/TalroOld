ROT = require 'lib/rotLove/rot' 
COLORS = require 'colors'
Class = require 'class'
require 'entity'
require 'map'
require 'player'
require 'util'

SCREEN_HEIGHT = 46
SCREEN_WIDTH = 78

moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
actionKeys = {['t'] = true}

map = {}
entities = {}
numEntities = 0

function love.load()
	--Setup tileset / display
	local spriteSheet = love.graphics.newImage('cheepicus_16x16.png') 
	map = Map(SCREEN_WIDTH, SCREEN_HEIGHT, spriteSheet)
	player = Player(40, 40, '@', ROT.Color.fromString('blue'), COLORS.YELLOW, map)
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

		if char == '\176' or char == '\220' or char == '\214' then
			pass = 0
		end
		map:setTile(x, y, char, pass, fore, back) 
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
		elseif actionKeys[t] then
			if t == 't' then
				gameState = 'whip'
			end
		end
	elseif gameState == 'whip' then
		if moveKeys[t] then
			player:whip(keyToDirection(t))
			gameState = 'playing'
		end
	end
end

function love.update()	
	--Draws characters on the virtual terminal but not the screen
	map:drawMap()
end

function love.draw() 
	map:renderMap()
end
