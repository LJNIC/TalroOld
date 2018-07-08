ROT = require 'lib/rotLove/rot'
UUID = require 'lib/uuid'
COLORS = require 'util/colors'
Logger = require 'logger'
Gamestate = require 'lib/gamestate'
PlayState = require 'states/play'
WhipState = require 'states/playwhip'
Util = require 'util/util'
Entity = require 'entities/entity'
Mummy = require 'entities/mummy'
Map = require 'map'
Player = require 'entities/player'

UUID.seed()

SCREEN_HEIGHT = 45
SCREEN_WIDTH = 78

moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
actionKeys = {['t'] = true}


function love.load()
	Logger.init()
	Gamestate.switch(PlayState)
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
