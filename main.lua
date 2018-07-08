ROT = require 'lib/rotLove/rot'
UUID = require 'lib/uuid'
COLORS = require 'util/colors'
TileTypes = require 'util/tileTypes'
Logger = require 'logger'
Gamestate = require 'lib/gamestate'
IntroState = require 'states/intro'
WhipState = require 'states/playwhip'
FloorOneState = require 'states/floorone'
Util = require 'util/util'
Entity = require 'entities/entity'
Mummy = require 'entities/mummy'
Door = require 'entities/door'
Map = require 'map'
Player = require 'entities/player'

--Seeds the uuid creator for entities
UUID.seed()

SCREEN_HEIGHT = 20
SCREEN_WIDTH = 33

moveKeys = {['w'] = true, ['d'] = true, ['s'] = true, ['a'] = true}
actionKeys = {['t'] = true}


function love.load()
	love.keyboard.setKeyRepeat(true)
	Logger.init()
	Gamestate.switch(IntroState)
end

function love.textinput(t)
	Gamestate.textinput(t)
end

function love.keypressed(key, scancode, isrepeat)
	Gamestate.keypressed(key)
end

function love.update(dt)	
	Gamestate.update(dt)
end

function love.draw() 
	Gamestate.draw()
end
