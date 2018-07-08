ROT = require 'lib/rotLove/rot'
Generator = require 'generator'
COLORS = require 'colors'
logger = require 'logger'
Gamestate = require 'lib/gamestate'
playstate = require 'states/play'
whipstate = require 'states/playwhip'
util = require 'util'
Entity = require 'entity'
Map = require 'map'
Player = require 'player'

SCREEN_HEIGHT = 45
SCREEN_WIDTH = 78

moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
actionKeys = {['t'] = true}

function love.load()
	logger.init()
	Gamestate.switch(playstate)
end

function love.textinput(t)
	Gamestate.textinput(t)
end

function love.update(dt)	
	Gamestate.update(dt)
end

function love.draw() 
	Gamestate.draw()
end
