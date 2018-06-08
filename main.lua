local ROT = require 'lib/rotLove/rot'
local COLORS = require 'colors'
logger = require 'logger'
local gener = require 'generator'
require 'entity'
require 'map'
require 'player'
require 'util'

SCREEN_HEIGHT = 45
SCREEN_WIDTH = 78

moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
actionKeys = {['t'] = true}

function love.load()
	logger.init()

	--Setup tileset / display
	local spriteSheet = love.graphics.newImage('cheepicus_16x16.png') 
	logger.log("Loaded map", "INFO")
	root = ROT.Display:new(SCREEN_WIDTH, SCREEN_HEIGHT, 1, spriteSheet, 16, 16, COLORS.YELLOW, COLORS.YELLOW)
	tunnelMap = Map(SCREEN_WIDTH, SCREEN_HEIGHT*2, root)

	hero = Player:new(SCREEN_WIDTH/2, 80, '@', COLORS.BLUE, COLORS.YELLOW, tunnelMap)

	if not tunnelMap:isPassable(hero.x, hero.y) then
		for x = 1, SCREEN_WIDTH do
			if tunnelMap:isPassable(x, hero.y) then
				hero.x = x
			end
		end
	end

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
		tunnelMap:setTile(x, y, char, pass, fore, back)
	end
	gameState = 'playing'
	tunnelMap:moveWindow({x=0, y=40})
end

function love.textinput(t)
	if gameState == 'playing' then
		if moveKeys[t] then
			if hero:move(keyToDirection(t)) then
				tunnelMap:moveWindow(keyToDirection(t))
			end
		elseif actionKeys[t] then
			if t == 't' then
				gameState = 'whip'
			end
		end
	elseif gameState == 'whip' then
		if moveKeys[t] then
			hero:whip(keyToDirection(t))
			gameState = 'playing'
		end
	end
end

function love.update(dt)	
	--Draws characters on the virtual terminal but not the screen
	tunnelMap:drawMap()
end

function love.draw() 
	tunnelMap:renderMap()
end
