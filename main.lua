ROT = require 'lib/rotLove/rot' 
COLORS = require 'colors'
Class = require 'class'
require 'player'
require 'map'

SCREEN_HEIGHT = 45
SCREEN_WIDTH = 78
map = {}
entities = {}
numEntities = 0

function love.load()
	--Setup tileset / display
	local spriteSheet = love.graphics.newImage('Cheepicus_8x8x2.png')
	player = Entity(4, 4, '@', COLORS.MAROON, COLORS.YELLOW)
	map = Map(SCREEN_WIDTH, SCREEN_HEIGHT, root, spriteSheet)
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

	while inBounds == false do
		playerx = love.math.random(SCREEN_WIDTH)
		playery = love.math.random(SCREEN_HEIGHT)
		if isPassable(playerx, playery) then
			inBounds = true
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

function love.update()	
end

function love.draw() 
	map:renderMap()
end
